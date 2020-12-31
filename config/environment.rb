# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

# setting to send email using the Heroku SendMail add-on
# edited 12/30/2020 to use API key instead of username + password
ActionMailer::Base.smtp_settings = {
    #:user_name => ENV['SENDGRID_USERNAME'],
    #:password => ENV['SENDGRID_PASSWORD'],
    :user_name => 'apikey',
    :password => ENV['SENDGRID_API_KEY'],
    :domain => 'comment-processor.herokuapp.com',
    :address => 'smtp.sendgrid.net',
    :port => 587,
    :authentication => :plain,
    :enable_starttls_auto => true
}