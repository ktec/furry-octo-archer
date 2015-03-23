module Domain
  module Github
    class Page
      def initialize(doc)
        @doc = doc
      end

      def try_process_with(p)
        doc = p.new(@doc)
        if doc.valid?
          save(doc.attributes, doc.find_by_attributes)
        else
          false
        end
      end

      def save(attributes, find_by)
        user = User.find_or_initialize_by(find_by)
        if user.new_record?
          user.update(attributes)
          puts "User: #{user.username} added..."
          #File.open('./tmp/profiles.txt', 'a') {|f| f.write(serialize) }
          user.save
          true
        end
        false
      end

    end
  end
end
