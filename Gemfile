source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

ruby '2.4.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2'

gem 'rails-html-sanitizer', '~> 1.0.4'

gem 'sprockets-rails' #-> this will add the latest version

gem 'pg' #'0.18.4' # upgraded from '0.17.1' #PostgreSQL

# Use puma as the app server
gem 'puma'

# Use SCSS for stylesheets
#gem 'bootstrap-sass', ">= 3.4.1"
#gem 'sass-rails', '~> 5.0'

gem 'bootstrap', '~> 4.3.1'

# Use jquery as the JavaScript library
gem 'jquery-rails'

gem 'jquery-ui-rails'

gem 'bootstrap-multiselect-rails', '~> 0.9.9'
#gem 'bootstrap-multiselect-rails4', '~> 0.0.1'

gem 'bootstrap-select-rails'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5.2.0'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

gem 'ruby_dep'

gem 'ruby_odata'

gem 'will_paginate'

gem 'trix-rails', require: 'trix'

gem 'rack', '>= 2.0.6' #specified due to security vulnerability mentioned by github
gem 'loofah', '>= 2.2.3' #specified due to security vulnerability mentioned by github
gem 'ffi', '>= 1.9.24' #specified due to security vulnerability mentioned by github

#for export to excel
gem 'rubyzip', '>= 1.2.2'
gem 'axlsx', git: 'https://github.com/randym/axlsx.git', ref: '776037c0fc799bb09da8c9ea47980bd3bf296874'
gem 'axlsx_rails'

#for storing files on Amazon S3
gem "aws-sdk-s3", require: false

gem "recaptcha"

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

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
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
