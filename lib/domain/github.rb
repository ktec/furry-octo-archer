require './db/database'
require './lib/domain/github/processor'
require './lib/domain/profile_base'
require './lib/domain/github/profile'

module Domain
  module Github
    INVALID_URLS = /login|search|blog|features|trending|showcases|site|about|security|plans|pricing|integrations|contact|join|explore/
  end
end
