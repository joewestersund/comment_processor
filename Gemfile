source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'dotenv-rails', groups: [:development, :test] #used to load environment variables from the .env file

#ruby '2.7.6'
ruby '2.7.7'
#ruby '3.0.4'

#gem 'rails', '~> 6.1.6.1'
gem 'rails', '~> 7.0.4'

#gem 'rake', '~> 12.3.3'
gem 'rake'

#gem 'rails-html-sanitizer', '~> 1.4.3'
gem 'rails-html-sanitizer', '~> 1.4.4'

gem 'sprockets-rails' #-> this will add the latest version

gem 'pg' #PostgreSQL

# Use puma as the app server
#gem 'puma', '~> 4.3.11'
gem 'puma', '~> 4.3.12'

gem 'bootstrap', '~> 4.3.1'

# Use jquery as the JavaScript library
gem 'jquery-rails'

gem 'jquery-ui-rails'

gem 'bootstrap-multiselect-rails', '~> 0.9.9'
#gem 'bootstrap-multiselect-rails4', '~> 0.0.1'

gem 'bootstrap-select-rails'

gem "font-awesome-rails"

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'

# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5.2.1'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

gem 'ruby_dep'

#gem 'ruby_odata' was only needed when importing comments from old DAS system that is now defunct

gem 'will_paginate'

gem 'trix-rails', require: 'trix'

#gem 'rack', '>= 2.2.3'
gem 'rack', '>= 2.2.3.1'
#gem 'loofah', '>= 2.2.3' #specified due to security vulnerability mentioned by github
gem 'loofah', '>= 2.19.1' #specified due to security vulnerability mentioned by github
gem 'ffi', '>= 1.9.24' #specified due to security vulnerability mentioned by github

#gem "nokogiri", ">= 1.13.9"
gem "nokogiri", ">= 1.13.10"

gem "websocket-extensions", ">= 0.1.5"  #specified due to security vulnerability mentioned by github
gem "json", '>=2.3.1' #specified due to security vulnerability mentioned by github
gem "addressable", ">= 2.8.0"

gem 'truncate_html' #from https://github.com/hgmnz/truncate_html

#for export to excel
gem 'rubyzip', '~> 1.3.0' #was '>= 1.2.2'
gem 'caxlsx'
gem 'caxlsx_rails'

#for storing files on Amazon S3
gem "aws-sdk-s3", require: false

gem "recaptcha"

gem "mini_racer", '0.4.0'  # to avoid "Cannot read property 'version' of undefined" bug with exec-js

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '~> 2.13'
  gem 'selenium-webdriver'
  gem "letter_opener"
end

group :development do
  #annotate models
  gem 'annotate'
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  #gem 'spring-watcher-listen' #, '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
