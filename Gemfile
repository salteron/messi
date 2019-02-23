# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.1'

gem 'pg'
gem 'puma', '~> 3.11'
gem 'rails', '~> 5.2.2'

gem 'config'
gem 'dry-validation', '~> 0.13'
gem 'sidekiq', '~> 5.2'

group :development, :test do
  gem 'bootsnap', '>= 1.1.0', require: false
  gem 'pry-rails'
  gem 'rspec-rails'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rubocop'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'factory_bot_rails'
  gem 'rspec-sidekiq'
  gem 'simplecov', require: false
end
