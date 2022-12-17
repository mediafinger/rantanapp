source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.2"

gem "rails", "7.0.4"

gem "bcrypt", "~> 3.1" # Use bcrypt for secure password hashing
gem "bootsnap", require: false
# gem "chimera_http_client", "~> 1.3" # HTTP client based on Typhoeus / lib_curl
gem "dry-validation", "~> 1.10" # Use dry-validation for validations [https://dry-rb.org/gems/dry-validation]
gem "importmap-rails" # Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
# gem "logstasher" # better formatted JSON logs for Logstash
# gem "pagy", "~> 5.10" # fast and lightweight pagination solution # TODO: require 'pagy/extras/navs' & https://ddnexus.github.io/pagy/extras/tailwind#gsc.tab=0
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
# gem "pundit", "~> 2.2" # Authorize actions by admin role
gem "rack-requestid", "~> 0.2" # always set a request_id with this middleware
gem "rack-timeout", "~> 0.6", require: "rack/timeout/base" # set a custom timeout in the middleware
gem "redis", "~> 4.0" # Use Redis for Action Cable / Turbo-Reflex
gem "resque", "~> 2.4" # Use Resque for background jobs
gem "sprockets-rails" # The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "stimulus-rails" # Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "tailwindcss-rails" # Use Tailwind CSS [https://github.com/rails/tailwindcss-rails]
gem "turbo-rails" # Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]

group :development do
  gem "web-console"
end

group :development, :test do
  gem "amazing_print", "~> 1.4"
  gem "bundler-audit", "~> 0.9"
  gem "factory_bot_rails", "~> 6.2"
  gem "factory_bot-awesome_linter"
  gem "faker", "~> 2.19"
  gem "rspec-rails", "~> 6.0"
end

group :test do
  gem "webmock", "~> 3.14"
end
