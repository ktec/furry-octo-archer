module Domain
  module Github
    module PageTypes
      class OrgProfile < Base
        def initialize(doc)
          @doc = doc
          @attributes = {
            github_id: %{css("[class='avatar']").first['data-user']},
          }
          raise WrongTemplateError unless valid?
        end

        def valid?
          username.present? && github_id > 0
        end

        def find_by_attributes
          attributes.slice(:github_id,:username)
        end

        private

        def fix_github_id(val)
          val.to_i
        end

      end
    end
  end
end
