module Domain
  module Github
    module PageTypes
      class UserProfile < Github::PageType
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
            total_public_contributions_last_year: %{css("[class='contrib-number']").first.text.scan(/[^[A-z]]\\S*/).first},
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

        def fix_following(val)
          val.to_i
        end

        def fix_stars(val)
          val.to_i
        end

        def fix_total_public_contributions_last_year(val)
          val.gsub(/[^\d]/, '').to_i
        end

        def fix_followers(val)
          (val[-1] == 'k' ? val[0...-1].to_f * 1000 : val).to_i
        end

      end
    end
  end
end
