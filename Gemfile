source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.1.3'

gem 'pg'
gem 'sassc-rails' # needed for activeadmin
gem 'rails', '~> 7.0'
gem 'puma', '~> 6.0'

gem 'sprockets-rails'
gem 'turbo-rails'
gem 'jsbundling-rails'
gem "stimulus-rails"
gem "cssbundling-rails"

gem 'redis', '~> 5.0'
# Use Active Model has_secure_password
gem 'bcrypt', '~> 3.1.7'

gem "activeadmin", "~> 2.12"
gem 'devise'
gem 'discard'
gem 'dotenv-rails'

gem 'barby'
gem 'httparty'
gem 'logtail-rails'
gem 'naturalsorter'
gem 'newrelic_rpm'
gem 'rack-brotli'
gem 'rqrcode'
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'

group :development, :test do
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'pry-byebug'
  gem 'rails-controller-testing'
  gem 'rspec-rails', '~> 6.0'
  gem 'simplecov', require: false
  gem 'bundler-audit'
end

group :development do
  # Access an interactive console on exception pages or by calling 'console' anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'sqlite3'
end

gem "action-cable-redis-backport", "~> 1.0"
