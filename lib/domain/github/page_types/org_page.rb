module Domain
  module Github
    module PageTypes
      class OrgPage < Base
        def initialize(doc)
          @doc = doc
          @attributes = {
            item_type: %{xpath("//*[@itemtype='http://schema.org/Organization']").attr('itemtype').text},
            email: %{css("[itemprop='email']").text},
            forked_projects: %{xpath(%{descendant::*[@class="repo-list-item public fork"]})},
            own_projects: %{xpath(%{descendant::*[@class="repo-list-item public source"]})},
            members: %{xpath(%{descendant::*[@class="member-avatar-group"]})},
          }
          raise WrongTemplateError unless valid?
        end

        def valid?
          item_type == 'http://schema.org/Organization'
        end

        def find_by_attributes
          attributes.slice(:github_id,:username)
        end

        private

        def fix_github_id(val)
          val.to_i
        end

        def fix_own_projects(val)
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
          end
          #val.gsub(/\s/,',').split(',') - [""]
          projects
        end

        def fix_members(val)
          members = []
          val.each_with_index do |node, index|
            member = {
              id: node.xpath("descendant::img[@class='avatar']").attr("data-user").value.to_i,
              username: node.xpath("descendant::img[@class='avatar']").attr("alt").value
            }
            members << member
          end
          members
        end

        def fix_forked_projects(val)
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
          end
          #val.gsub(/\s/,',').split(',') - [""]
          projects
        end

      end
    end
  end
end
