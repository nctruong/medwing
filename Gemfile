source 'https://rubygems.org'
ruby '2.5.1'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


gem 'rails', '~> 5.2.0', '>= 5.1.6.1'
gem 'pg'
gem 'puma', '~> 3.7'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'pry-rails'

  gem 'rspec-rails', '~> 3.5.2'
  gem 'factory_bot_rails'
  gem 'faker'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

  gem 'seed_dump'
end

group :test do
  gem 'rspec-sidekiq'
  gem 'database_cleaner', '~> 1.7.0'
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'chromedriver-helper'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem 'redis-rails'
gem 'redis'
gem 'redis-namespace'
gem 'redis-rack-cache'
gem 'sidekiq'
gem 'httparty'
gem 'bunny'
gem 'json'
gem 'sneakers'
gem 'rabbitmq_http_api_client', '>= 1.9.1'
gem 'dotenv-rails'
gem 'foreman'
