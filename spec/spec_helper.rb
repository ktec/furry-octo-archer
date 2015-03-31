$:.unshift File.join(File.dirname(__FILE__), "../lib") # current directory

require 'byebug'
require 'fakeweb'
require 'fileutils'
require 'anemone'

require 'domain'
require 'github'


RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.before(:all) do
    FakeWeb.allow_net_connect = false
  end

  config.after(:all) do
  end

  config.after(:each) do
    FakeWeb.clean_registry
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end


class TestDomain < Domain
  module PageTypes
    class Type1
      def initialize(doc)
      end
      def valid?
        false
      end
    end
    class Type2
      def initialize(doc)
        self
      end
      def valid?
        false
      end
    end
  end
end

include TestDomain::PageTypes
