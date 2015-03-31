class Domain
  WrongTemplateError = Class.new(TypeError)

  module PageTypes
  end

  def crawl(level: 1)
    Anemone.crawl(@start_url, :depth_limit => 3) do |anemone|
      anemone.focus_crawl { |page|
        filter(page.links)
      }
      #anemone.storage = Anemone::Storage.SQLite3(test_file)
      #anemone.storage = Anemone::Storage.MongoDB
      #anemone.storage = Anemone::Storage.Redis
      anemone.on_every_page do |page|
        if page.code == 200 && page.url.to_s !~ Github::INVALID_URLS
          process_page(page)
        end
      end
    end
  end

  private
  def self.page_types
    @page_types ||= self::PageTypes::constants.map {|const|
      PageTypes.const_get(const) if Class === PageTypes.const_get(const)
    }.to_enum
  end

  def self.process_page(page)
    klazz = page_types.next
    begin
      doc = klazz.new(page)
      if doc.valid?
        process_template(doc)
      else
        process_page(page)
      end
    end
  rescue StopIteration
    return "No template found"
  end

  def self.process_template(doc)
    # save to database
  end

  def self.filter(links=[])
    links.select { |link|
      link.request_uri !~ Github::INVALID_URLS
    }
  end
  
end
