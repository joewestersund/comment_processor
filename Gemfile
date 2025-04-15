source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'dotenv-rails', groups: [:development, :test] #used to load environment variables from the .env file

#ruby '3.2.7'
ruby '3.3.7'

#gem 'rails', '~> 7.0.8.7'
gem 'rails', '~> 7.1'

#gem 'rake', '~> 12.3.3'
gem 'rake'

# prevent code from running after web page has timed out
# defaults to 15 second timeout
gem "rack-timeout"

#gem 'rails-html-sanitizer', '~> 1.4.4'
gem 'rails-html-sanitizer'


gem 'pg' #PostgreSQL

# Use puma as the app server
#gem 'puma', '~> 5.6.8'
gem 'puma', '~> 5.6.9'

#gem 'bootstrap', '~> 5.0.0'
gem 'bootstrap', '~> 5.3.3'

# Use jquery as the JavaScript library
gem 'jquery-rails'

#gem "jquery-ui-rails", "~> 7.0.0"
#gem "jquery-ui-rails", :git => 'https://github.com/jquery-ui-rails/jquery-ui-rails.git'   #using this since 7.0.0 not pushed to rubygems yet. https://github.com/jquery-ui-rails/jquery-ui-rails/issues/146
gem "jquery-ui-rails"

gem "tom-select-rails"

gem "font-awesome-sass"


gem "propshaft", "~> 1.1"

gem "jsbundling-rails"
gem "cssbundling-rails"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

gem 'will_paginate'

gem 'trix-rails', require: 'trix'

#gem 'rack', '~> 2.2.8.1'
gem 'rack', '~> 2.2.11'

#gem 'loofah', '>= 2.2.3' #specified due to security vulnerability mentioned by github
gem 'loofah', '>= 2.19.1' #specified due to security vulnerability mentioned by github
gem 'ffi', '>= 1.9.24' #specified due to security vulnerability mentioned by github

#gem "nokogiri", "~> 1.16.5"
gem "nokogiri", "~> 1.18.5"

gem "websocket-extensions", ">= 0.1.5"  #specified due to security vulnerability mentioned by github
gem "json", '>=2.3.1' #specified due to security vulnerability mentioned by github
gem "addressable", ">= 2.8.0"

gem 'truncate_html' #from https://github.com/hgmnz/truncate_html

#for export to excel
gem 'rubyzip', '~> 1.3.0' #was '>= 1.2.2'
gem 'caxlsx'
gem 'caxlsx_rails'

#gem 'rexml', '~> 3.3.6'
gem 'rexml', '~> 3.3.9'

#for storing files on Amazon S3
gem "aws-sdk-s3", require: false

gem "recaptcha"

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
  gem 'listen' #, '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  #gem 'spring-watcher-listen' #, '~> 2.0.0'
end
