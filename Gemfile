source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5.1'
gem 'pg'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'us_web_design_standards'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

gem 'omniauth'
gem 'omniauth-github'

gem 'chronic'
gem 'email_validator'
gem 'redcarpet'
gem 'puma'
gem 'samwise', github: '18f/samwise', branch: 'micropurchase-compatibility'
gem 'octokit', '~> 4.0'

gem 'active_model_serializers'

gem 'business_time'

group :test do
  gem "codeclimate-test-reporter", require: nil
  gem 'webmock'
  gem 'json-schema'
  gem 'db-query-matchers'
end

group :development, :test do
  gem 'rspec-rails'

  gem 'cucumber-rails', require: false

  gem 'capybara'
  gem 'capybara-screenshot'
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
end

group :development do
  gem 'web-console', '~> 2.0'
  gem 'rails-erd'
  gem 'rubocop'
end

group :production do
  gem 'cf-app-utils'
  gem 'rails_12factor'
end
