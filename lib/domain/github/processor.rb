require 'anemone'
require 'fileutils'

module Domain
  module Github
    class Processor
      def initialize(start_url)
        @start_url = start_url
      end

      def process_page(page)
        save_page(page)

        profile = Profile.new(page.doc)
        profile.save
      end

      def save_page(page)
        dir = './tmp' + page.url.path
        FileUtils::mkdir_p dir
        File.open(dir + '/page.html', 'a') {|f| f.write(page.body) }
      end

      def filter(links=[])
        links.select { |link|
          link.request_uri !~ Github::INVALID_URLS
        }
      end

      def run
        Anemone.crawl(@start_url, :depth_limit => 3) do |anemone|
          anemone.focus_crawl { |page|
            filter(page.links)
          }
          #anemone.storage = Anemone::Storage.SQLite3(test_file)
          #anemone.storage = Anemone::Storage.MongoDB
          #anemone.storage = Anemone::Storage.Redis
          anemone.on_every_page do |page|
            process_page(page) if page.code == 200 &&
                                  page.url.to_s !~ Github::INVALID_URLS
          end
        end
      end
    end
  end
end
