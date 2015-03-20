source 'https://rubygems.org'
ruby '2.2.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails'
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc',          group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring',        group: :development

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

# env variables
gem 'foreman'

# Sidekiq for background jobs (sinatra is required)
gem 'sidekiq'
gem 'sinatra', require: false

# Error reporting
gem 'airbrake'

# Performance
gem 'newrelic_rpm'

# Cache
gem 'dalli'

# Data related

# Admin route
gem 'activeadmin', github: 'gregbell/active_admin'

# Controllers stuff
gem 'inherited_resources'

# Models stuff
gem 'friendly_id'
gem 'state_machine', require: 'state_machine/core'
gem 'draper'
gem 'rails-observers'

# Frontend stuff

# Templating
gem 'haml-rails'
gem 'slim-rails'
gem 'selected'

# Js
gem 'lazy_high_charts'
gem 'jquery-turbolinks'
gem 'gattica', :git => 'git://github.com/chrisle/gattica.git'

# Css / sass
gem 'compass-rails'
gem 'compass-inuit'
gem 'font-awesome-rails'
gem 'materialize-sass'

# Pagination
gem 'kaminari'

# Autoformat
gem 'redcarpet'
gem 'rails_autolink'
gem 'auto_html'

# Forms
gem 'formtastic'
gem 'simple_form'
gem 'ransack'
gem 'countries', github: 'hexorx/countries'
gem 'country_select'
gem 'by_star'

# Authentication and Authorization
gem 'devise'
gem 'cancancan'

# Payment
gem 'stripe', :git => 'https://github.com/stripe/stripe-ruby'
gem 'omniauth-stripe-connect'

# Social networks
gem 'twitter'
gem 'omniauth-twitter'

# Uploads
gem 'paperclip'

# Controller simplification
gem 'decent_exposure', github: 'voxdolo/decent_exposure'

# Other Tools
gem 'gon'

# Geolocation
gem 'geocoder'
gem 'gmaps-autocomplete-rails'
gem 'oj'
gem 'oj_mimic_json'

# Translations
gem 'globalize'
gem 'http_accept_language'
gem 'routing-filter', :github => 'svenfuchs/routing-filter'

# Server
gem 'passenger'

# Factories (a lot for the tests)
gem 'factory_girl_rails'

# Content
gem 'high_voltage'

group :development do
  gem 'annotate_yaml'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'parallel_tests'
  gem 'pry'
end

group :test do
  gem 'delorean'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'rspec-rails'
  gem 'capybara'
  gem 'cucumber-rails', require: false, github: 'cucumber/cucumber-rails'
  gem 'poltergeist'
  gem 'email_spec'
  gem 'mocha'
end

group :test, :development do
  gem 'byebug'
  gem 'dotenv-rails'
end

group :production do
  gem 'rails_12factor'
end
