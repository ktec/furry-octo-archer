module Domain
  module Github
    class Profile < Domain::ProfileBase
      def initialize(doc)
        @doc = doc
        @attributes = {
          github_id: %{css("[class='avatar']").first['data-user']},
          fullname: %{css("[class='vcard-fullname']").text},
          username: %{css("[class='vcard-username']").text},
          worksfor: %{css("[class='vcard-detail'][itemprop='worksFor']").text},
          email: %{css("[class='email']").text},
          location: %{css("[class='vcard-detail'][itemprop='homeLocation']").text},
          join_date: %{css("[class='join-date']").first["datetime"]},
        }
      end

      private
      def find_by_attributes
        attributes.slice(:github_id)
      end

    end
  end
end
