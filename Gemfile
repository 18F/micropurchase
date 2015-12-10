source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.4'
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

group :test do
  gem "codeclimate-test-reporter", require: nil
end

group :development, :test do
  gem 'rspec-rails'
  gem 'capybara'
  gem 'capybara-screenshot'
  gem 'byebug'
  gem 'pry'
  gem 'timecop'
  gem 'brakeman', require: false
  gem 'hakiri',  require: false
end

group :development do
  gem 'web-console', '~> 2.0'
  gem 'rails-erd'
end

group :production do
  gem 'cf-app-utils'
  gem 'rails_12factor'
end
