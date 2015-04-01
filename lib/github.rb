require 'domain'

class Github < Domain

  PATH_BLACKLIST=/login|search|blog|features|trending|showcases|site|about|security|plans|pricing|integrations|contact|join|explore/

  module PageTypes

    class BaseType

      attr_reader :doc

      def initialize(doc)
        @doc = doc
      end

      def valid?
        false
      end

      def method_missing(method_sym, *arguments, &block)
        if method_sym.to_s =~ /^(.*)=$/
          instance_variable_set "@#{$1}", safely_extract(arguments.first).to_s
        else
          super
        end
      end

      def safely_extract(query)
        begin
          doc.instance_eval(query)
        rescue
          nil
        end
      end

    end

    class UserPage < BaseType

      attr_reader :github_id,
                  :fullname,
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
        super
        self.github_id = %{css("[class='avatar']").first['data-user']}
        self.fullname = %{css("[class='vcard-fullname']").text}
        self.username = %{css("[class='vcard-username']").text}
        self.worksfor = %{css("[class='vcard-detail'][itemprop='worksFor']").text}
        self.email = %{css("[class='email']").text}
        self.location = %{css("[class='vcard-detail'][itemprop='homeLocation']").text}
        self.join_date = %{css("[class='join-date']").first["datetime"]}
        self.followers = %{css("[class='vcard-stat'][href='/#{username}/followers']").css("strong").text}
        self.stars = %{css("[class='vcard-stat'][href='/stars/#{username}']").css("strong").text}
        self.following = %{css("[class='vcard-stat'][href='/#{username}/following']").css("strong").text}
        self.total_public_contributions_last_year = %{css("[class='contrib-number']").first.text.scan(/[^[A-z]]\\S*/).first}
      end

      def valid?
        true unless username.empty? or github_id.zero?
      end

      private

      def github_id=(query)
        @github_id = safely_extract(query).to_s.to_i
      end

      def followers=(query)
        val = safely_extract(query).to_s
        @followers = (val[-1] == 'k' ? val[0...-1].to_f * 1000 : val).to_i
      end

      def total_public_contributions_last_year=(query)
        val = safely_extract(query).to_s
        @total_public_contributions_last_year = val.gsub(/[^\d]/, '').to_i
      end

      def following=(query)
        @following = safely_extract(query).to_s.to_i
      end

      def stars=(query)
        @stars = safely_extract(query).to_s.to_i
      end

    end

    class OrgPage < BaseType

      attr_reader :item_type,
                  :org_name,
                  :github_id,
                  :email,
                  :forked_projects,
                  :own_projects,
                  :members

      def initialize(doc)
        super
        self.item_type = %{xpath("//*[@itemtype='http://schema.org/Organization']").attr('itemtype').text}
        self.org_name = %{xpath("//*[@class='org-name']/span").text}
        self.github_id = %{css("[class='avatar']").attr('data-user')}
        self.email = %{css("[itemprop='email']").text}
        self.forked_projects = %{xpath(%{descendant::*[@class="repo-list-item public fork"]})}
        self.own_projects = %{xpath(%{descendant::*[@class="repo-list-item public source"]})}
        self.members = %{xpath(%{descendant::*[@class="member-avatar-group"]})}
      end

      def valid?
        true unless org_name.empty? or github_id.zero?
      end

      private

      def github_id=(query)
        @github_id = safely_extract(query).to_s.to_i
      end

      def forked_projects=(query)
        val = safely_extract(query)
        projects = []
        val.each_with_index do |node, index|
          project = {
            language: node.xpath("descendant::*[@itemprop='programmingLanguage']").text.strip,
            name: node.xpath("descendant::*[@itemprop='name codeRepository']").text.strip,
            description: node.xpath("descendant::*[@itemprop='description']").text.strip,
            stars: node.xpath("descendant::*[@aria-label='Stargazers']").text.strip.to_i,
            forks: node.xpath("descendant::*[@aria-label='Forks']").text.strip.to_i,
            forked_from: node.xpath("descendant::*[@class='repo-list-info']/a").attr("href").text.strip,
            updated: node.xpath("descendant::time").attr("datetime").text.strip
          }
          projects << project
        end if val
        #val.gsub(/\s/,',').split(',') - [""]
        @forked_projects = projects
      end

      def own_projects=(query)
        val = safely_extract(query)
        projects = []
        val.each_with_index do |node, index|
          project = {
            language: node.xpath("descendant::*[@itemprop='programmingLanguage']").text.strip,
            name: node.xpath("descendant::*[@itemprop='name codeRepository']").text.strip,
            description: node.xpath("descendant::*[@itemprop='description']").text.strip,
            stars: node.xpath("descendant::*[@aria-label='Stargazers']").text.strip.to_i,
            forks: node.xpath("descendant::*[@aria-label='Forks']").text.strip.to_i
          }
          projects << project
        end if val
        @own_projects = projects
      end

      def members=(query)
        val = safely_extract(query)
        members = []
        val.each_with_index do |node, index|
          member = {
            id: node.xpath("descendant::img[@class='avatar']").attr("data-user").value.to_i,
            username: node.xpath("descendant::img[@class='avatar']").attr("alt").value
          }
          members << member
        end if val
        @members = members
      end

    end

  end
end
