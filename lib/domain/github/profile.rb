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
          followers: Proc.new{%{css("[class='vcard-stat'][href='/#{username}/followers']").css("strong").text}},
          stars: Proc.new{%{css("[class='vcard-stat'][href='/stars/#{username}']").css("strong").text}},
          following: Proc.new{%{css("[class='vcard-stat'][href='/#{username}/following']").css("strong").text}},
          total_public_contributions_last_year: %{css("[class='contrib-number']").first.text},
        }
      end

      private
      def find_by_attributes
        attributes.slice(:github_id)
      end

    end
  end
end
