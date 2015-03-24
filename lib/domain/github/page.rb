module Domain
  module Github
    WrongTemplateError = Class.new(TypeError)
    class Page
      attr_accessor :klazzes

      def initialize(page)
        @page = page
      end

      def parse
        klazz = klazzes.next
        begin
          doc = klazz.new(@page.doc)
          if doc.valid?
            save(doc.attributes, doc.find_by_attributes)
          end
        rescue WrongTemplateError
          write_page
          parse
        end
      rescue StopIteration
        puts "finished..."
      end

      def write_page
        dir = './tmp' + @page.url.path
        FileUtils::mkdir_p dir
        File.open(dir + '/page.html', 'a') {|f| f.write(@page.body) }
      end

      def save(attributes, find_by)
        user = User.find_or_initialize_by(find_by)
        if user.new_record?
          user.update(attributes)
          puts "User: #{user.username} added..."
          #File.open('./tmp/profiles.txt', 'a') {|f| f.write(serialize) }
          user.save
        end
      end

    end
  end
end
