require 'rubygems'
require 'spork'
require 'database_cleaner'
require 'capybara/rspec'
require 'capybara/poltergeist'
#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

# Capybara.
Capybara.javascript_driver = :poltergeist
Capybara.run_server = true
Capybara.server_port = 8000
Capybara.app_host = "http://localhost:#{Capybara.server_port}"

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'

  # This file is copied to spec/ when you run 'rails generate rspec:install'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    config.fixture_path = "#{::Rails.root}/spec/fixtures"
    config.use_transactional_fixtures = false 
    config.infer_base_class_for_anonymous_controllers = false
    config.order = "random" #--seed 1234
    #config.order = 17553

    # Database cleaner.
    config.before(:suite) do
      DatabaseCleaner.clean_with(:truncation)
    end
    config.before(:each) do
      DatabaseCleaner.strategy = :transaction
    end
    config.before(:each, :js => true) do
      DatabaseCleaner.strategy = :truncation
    end
    config.before(:each) do
      DatabaseCleaner.start
    end
    config.after(:each) do
      DatabaseCleaner.clean
    end
  end
end

Spork.each_run do
  FactoryGirl.reload
end

