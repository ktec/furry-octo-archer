module Domain
  module Github
    module PageTypes
      class OrgPage < Base
        def initialize(doc)
          @doc = doc
          @attributes = {
            item_type: %{xpath("//*[@itemtype='http://schema.org/Organization']").attr('itemtype').text},
            email: %{css("[itemprop='email']").text},
            projects: %{xpath(%{descendant::*[@class="repo-list-item public source"]})},
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

        def fix_projects(val)
          projects = []
          val.each_with_index do |node, index|
            project = {
              language: node.xpath("descendant::*[@itemprop='programmingLanguage']").text.strip,
              name: node.xpath("descendant::*[@itemprop='name codeRepository']").text.strip,
              description: node.xpath("descendant::*[@itemprop='description']").text.strip,
              stars: node.xpath("descendant::*[@aria-label='Stargazers']").text.strip,
              forks: node.xpath("descendant::*[@aria-label='Forks']").text.strip
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
