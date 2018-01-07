require 'rails_helper'
require 'capybara/poltergeist'

RSpec.configure do |config|
  
  Capybara.javascript_driver = :poltergeist
  Capybara.default_max_wait_time = 15

  config.include AcceptanceHelpers, type: :feature

  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :deletion
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.before(:each) do
    DatabaseCleaner.clean
  end
end