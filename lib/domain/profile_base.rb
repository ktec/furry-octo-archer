module Domain
  class ProfileBase

    def valid?
      @attributes.map{|k,v| self.send(k).empty? if self.send(k) }.include?(false)
    end

    def serialize
      attributes.map{|k,v| "#{k}: #{v}"}.join("\t") + "\n"
    end

    def save
      if valid?
        user = User.find_or_initialize_by(find_by_attributes)

        if user.new_record?
          user.update(attributes)
          #File.open('./tmp/profiles.txt', 'a') {|f| f.write(profile.serialize) }
          puts serialize
          user.save
        end
      end
    end

    def attributes
      @attributes.each_with_object({}) {|(k,v),o|
        o[k.to_sym]=safe_get_attribute(k)
      }
    end

    private
    def find_by_attributes
      attributes
    end

    def safe_get_attribute(attr)
      begin
        query = @attributes[attr]
        query = Proc.new{@attributes[attr]} unless query.is_a? Proc
        send("fix_#{attr.to_s}", @doc.instance_eval(query.call))
      rescue
        ""
      end
    end

    def method_missing(method_sym, *arguments, &block)
      if @attributes.include?(method_sym)
        safe_get_attribute(method_sym)
      elsif method_sym.to_s =~ /^fix_(.*)$/
        arguments[0]
      else
        super
      end
    end

  end
end
