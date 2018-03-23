require 'rails_helper'
require 'capybara/poltergeist'
require 'capybara/rspec'
require 'capybara-screenshot/rspec'
require "selenium/webdriver"

RSpec.configure do |config|
  Capybara.register_driver :chrome do |app|
    Capybara::Selenium::Driver.new(app, browser: :chrome, js_errors: true)
  end
  
  Capybara.register_driver :headless_chrome do |app|
    capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
      chromeOptions: { args: %w(headless disable-gpu) }
    )
  
    Capybara::Selenium::Driver.new app,
      browser: :chrome,
      desired_capabilities: capabilities
  end
  
  Capybara.javascript_driver = :headless_chrome
  Capybara.server = :puma
  Capybara.server_port = 3001


  ActionDispatch::IntegrationTest
  Capybara.app_host = 'http://myapp.local:3001'
  # Capybara.server_port = "3030"
  # Capybara.javascript_driver = :poltergeist
 
  # options = {
  #   js_errors: false,

  # }
  # Capybara.register_driver :poltergeist do |app|
  #   Capybara::Poltergeist::Driver.new(app, options)
  # end
  Capybara.default_max_wait_time = 25
  Capybara::Screenshot.autosave_on_failure = true
  Capybara::Screenshot.prune_strategy = :keep_last_run

  config.include AcceptanceHelpers, type: :feature
  config.include WaitForAjax, type: :feature
  
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