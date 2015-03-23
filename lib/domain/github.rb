require './db/database'
require './lib/domain/github/page'
require './lib/domain/github/processor'
require './lib/domain/github/page_type'
require './lib/domain/github/page_types/user_profile'

module Domain
  module Github
    INVALID_URLS = /login|search|blog|features|trending|showcases|site|about|security|plans|pricing|integrations|contact|join|explore/
  end
end
