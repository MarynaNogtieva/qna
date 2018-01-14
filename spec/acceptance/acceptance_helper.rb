require 'rails_helper'
require 'capybara/poltergeist'
require 'capybara/rspec'
require 'capybara-screenshot/rspec'

RSpec.configure do |config|
  Capybara.javascript_driver = :poltergeist
 
  options = {
    js_errors: false,

  }
  Capybara.register_driver :poltergeist do |app|
    Capybara::Poltergeist::Driver.new(app, options)
  end
  Capybara.default_max_wait_time = 30
  Capybara::Screenshot.autosave_on_failure = true
  Capybara::Screenshot.prune_strategy = :keep_last_run

  config.include AcceptanceHelpers, type: :feature
  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end