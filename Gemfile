source 'https://rubygems.org'

ruby '2.3.1'

gem 'rails', '4.2.6'
gem 'pg'
gem 'sass-rails', '~> 5.0'
gem 'uglifier'
gem 'omniauth'
gem 'omniauth-github'
gem 'clockwork'
gem 'chronic'
gem 'email_validator'
gem 'kaminari'
gem 'validate_url'
gem 'redcarpet'
gem 'puma'
gem 'samwise', '~> 0.4.0'
gem 'octokit', '~> 4.0'
gem 'rack-cors', require: 'rack/cors'
gem 'active_model_serializers'
gem 'business_time'
gem 'holidays'
gem 'simple_form'
gem 'delayed_job_active_record'
gem 'daemons'
gem 'foreman'
gem 'c2', github: '18f/c2-api-client-ruby'
gem 'jquery-rails-cdn'
gem 'jquery-rails'
gem 'selectize-rails'

gem 'rouge-rails'
gem 'swagger_jekyll', github: "harrisj/swagger-jekyll", branch: "develop"

group :test do
  gem "codeclimate-test-reporter", require: nil
  gem 'codeclimate_batch', require: nil
  gem 'dotenv'
  gem 'db-query-matchers'
  gem 'json-schema'
  gem 'shoulda-matchers'
  gem 'sinatra'
  gem 'webmock'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'cucumber-rails', require: false
  gem 'capybara'
  gem 'poltergeist'
  gem 'byebug'
  gem 'pry'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'faker'
  gem 'timecop'
  gem 'brakeman', require: false
  gem 'hakiri', require: false
  gem 'dotenv-rails'
  gem 'jasmine'
  gem 'apivore'
end

group :development do
  gem 'letter_opener'
  gem 'letter_opener_web'
  gem 'rails-erd'
  gem 'rubocop'
  gem 'web-console', '~> 2.0'
end

group :production, :staging do
  gem 'cf-app-utils'
  gem 'rails_12factor'
  gem 'newrelic_rpm'
end
