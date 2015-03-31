require 'anemone'

class Domain

  module PageTypes
  end

  attr_accessor :start_url, :db_adapter

  def initialize(start_url: , db_adapter: )
    @start_url = start_url
    @db_adapter = db_adapter
  end

  def crawl(level: 1)
    Anemone.crawl(@start_url, :depth_limit => 1) do |anemone|
      anemone.focus_crawl { |page|
        self.filter(page.links)
      }
      #anemone.storage = Anemone::Storage.SQLite3(test_file)
      #anemone.storage = Anemone::Storage.MongoDB
      #anemone.storage = Anemone::Storage.Redis
      anemone.on_every_page do |page|
        if page.code == 200 && page.url.to_s
          process_page(page)
        end
      end
    end
  end

  def page_types
    @page_types ||= self.class::PageTypes::constants.map {|const|
      self.class::PageTypes.const_get(const) if Class === self.class::PageTypes.const_get(const)
    }.to_enum
  end

  def process_page(page)
    puts "Processing #{page.url}"
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
    page_types.rewind
    return "No template found"
  end

  def process_template(doc)
    # save to database
    byebug
    @db_adapter.save(doc)
  end

  def filter(links=[])
    links.select { |link|
      link.request_uri !~ Github::INVALID_PATHS
    }
  end

end
