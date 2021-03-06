source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.4'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 3.7'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development
gem 'dotenv-rails', require: 'dotenv/rails-now'
gem 'slim-rails'
gem 'twitter-bootstrap-rails'
gem 'jquery-rails'
gem 'devise'
gem 'carrierwave'
gem 'cocoon'
gem 'gon'
gem 'skim'
gem 'sprockets'
gem 'responders', '~> 2.0'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'cancancan'
gem 'doorkeeper', '4.2.6'
gem 'active_model_serializers', '~> 0.9.3'
# helps convert to json much faster than regular to_json method
gem 'oj'
gem 'oj_mimic_json'
gem 'sidekiq'
gem 'sinatra', '>= 1.3.0', require: nil
gem 'whenever', require: false
# tasks that work well with sidekiq
gem 'sidetiq'

# if gem doesn't work, install from console
# gem install mysql2 --  --with-mysql-dir=/usr/local/opt/mysql@5.6
# be rake ts:configure
# be rake ts:index
# be rake ts:restart
gem 'mysql2'
gem 'thinking-sphinx'
# gem 'dotenv'
# gem 'dotenv-deployment', require: 'dotenv/deployment'
gem 'unicorn'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'geckodriver-helper'
  # to be able to see how the looks for the user
  gem 'launchy'
  gem 'poltergeist'
  gem 'database_cleaner'
  gem 'selenium-webdriver'
  gem 'letter_opener'
  gem 'capistrano3-unicorn', require: false
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  #===================CAPISTRANO===================
  #put false so that code of these gems does not load when we start application
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-sidekiq', require: false
end

group :test do
  gem 'shoulda-matchers'
  gem 'rails-controller-testing'
  gem 'capybara-screenshot'
  gem 'capybara-selenium'
  gem 'capybara-email'
  gem 'json_spec'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
