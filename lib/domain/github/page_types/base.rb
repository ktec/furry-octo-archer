module Domain
  module Github
    module PageTypes
      class Base
        def valid?
          raise NotImplementedError.new("You must implement #valid?")
        end

        def find_by_attributes
          raise NotImplementedError.new("You must implement #find_by_attributes")
        end

        def attributes
          @attributes.each_with_object({}) {|(k,v),o|
            o[k.to_sym]=safe_get_attribute(k)
          }
        end

        private
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
  end
end
