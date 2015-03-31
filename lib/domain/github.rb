require 'domain/github/page'
require 'domain/github/processor'
require 'domain/github/page_types/base'
require 'domain/github/page_types/user_page'
require 'domain/github/page_types/org_page'

module Domain
  module Github
    INVALID_URLS = /login|search|blog|features|trending|showcases|site|about|security|plans|pricing|integrations|contact|join|explore/
  end
end
