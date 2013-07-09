source 'https://rubygems.org'

ruby '2.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'
gem 'rails_12factor' # Heroku integration: https://devcenter.heroku.com/articles/rails-integration-gems

gem 'pg'
gem 'sidekiq'
gem 'sidekiq-limit_fetch'

gem 'fog'
gem 'geoip'

# Assets
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'

gem 'rack-status'
# gem 'honeybadger'

group :production do
  gem 'rack-devise_cookie_auth'
  gem 'unicorn'
  gem 'newrelic_rpm'
  gem 'newrelic-redis'
end

group :development, :test do
  gem 'rspec-rails'
  gem 'dotenv-rails'
end

group :development do
  gem 'annotate'
  gem 'foreman'

  # Guard
  gem 'ruby_gntp'
  gem 'guard-rspec'
end

group :test do
  gem 'rspec'
  gem 'shoulda-matchers'
  gem 'factory_girl_rails'
end
