class Github < Domain

  INVALID_PATHS=/login|search|blog|features|trending|showcases|site|about|security|plans|pricing|integrations|contact|join|explore/
  URL="https://github.com/search?o=desc&q=ruby&s=repositories&type=Users&utf8=%E2%9C%93"

  module PageTypes

    class UserPage # responsiblity?

      attr_accessor :github_id,
                    :username,
                    :worksfor,
                    :location,
                    :join_date,
                    :email,
                    :followers,
                    :following,
                    :stars,
                    :total_public_contributions_last_year


      def initialize(doc)
        # extract data to instance property...
        @github_id = safely_extract(doc,%{css("[class='avatar']").first['data-user']},:to_i)
        @fullname = safely_extract(doc,%{css("[class='vcard-fullname']").text})
        @username = safely_extract(doc,%{css("[class='vcard-username']").text})
        @worksfor = safely_extract(doc,%{css("[class='vcard-detail'][itemprop='worksFor']").text})
        @email = safely_extract(doc,%{css("[class='email']").text})
        @location = safely_extract(doc,%{css("[class='vcard-detail'][itemprop='homeLocation']").text})
        @join_date = safely_extract(doc,%{css("[class='join-date']").first["datetime"]})
        @followers = fix_followers(safely_extract(doc,%{css("[class='vcard-stat'][href='/#{username}/followers']").css("strong").text}))
        @stars = safely_extract(doc,%{css("[class='vcard-stat'][href='/stars/#{username}']").css("strong").text},:to_i)
        @following = safely_extract(doc,%{css("[class='vcard-stat'][href='/#{username}/following']").css("strong").text},:to_i)
        @total_public_contributions_last_year = fix_total_public_contributions_last_year(safely_extract(doc,%{css("[class='contrib-number']").first.text.scan(/[^[A-z]]\\S*/).first}))
      end

      def safely_extract(doc,query,func=:to_s)
        begin
          doc.instance_eval(query).send(func)
        rescue
          nil
        end
      end

      def valid?
        username.present? && github_id > 0
      end

      def fix_followers(val)
        (val[-1] == 'k' ? val[0...-1].to_f * 1000 : val).to_i
      end

      def fix_total_public_contributions_last_year(val)
        val.gsub(/[^\d]/, '').to_i
      end

    end
  end
end
