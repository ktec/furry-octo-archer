module Domain
  module Github
    WrongTemplateError = Class.new(TypeError)
    class Page
      attr_accessor :klazzes

      def initialize(doc)
        @doc = doc
      end

      def parse
        klazz = klazzes.next
        begin
          doc = klazz.new(@doc)
          if doc.valid?
            save(doc.attributes, doc.find_by_attributes)
          end
        rescue WrongTemplateError
          parse
        end
      rescue StopIteration
        puts "finished..."
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
