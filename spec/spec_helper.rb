require 'byebug'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.before(:all) do
  end

  config.after(:all) do
  end

  config.after(:each) do
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
