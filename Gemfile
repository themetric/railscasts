source 'http://rubygems.org'

gem "rails", "3.1.0"
gem "mysql2"
gem "pg" 
gem "redcarpet"
gem "coderay"
gem "thinking-sphinx", ">= 2.0.1", :require => "thinking_sphinx"
gem "whenever", :require => false
gem "will_paginate", ">= 3.0.pre2"
gem "jquery-rails"
gem "omniauth", ">= 0.2.2"
gem "exception_notification", :git => "git://github.com/rails/exception_notification.git", :require => "exception_notifier"
gem "ancestry"
gem "cancan", :git => "git://github.com/ryanb/cancan.git", :branch => "2.0"
gem "paper_trail"
gem "therubyracer"
gem "execjs" 
gem "omniauth-github" 
gem "devise" 
gem "paperclip" 
gem "aws-sdk"
gem "aws-s3", :require => "aws/s3"

group :development, :test do
  gem "rspec-rails"
  gem "launchy"
end

group :test do
  gem "factory_girl_rails"
  gem "capybara"
  gem "database_cleaner"
  gem "guard"
  gem "guard-rspec"
  gem "fakeweb"
  gem "simplecov", :require => false
end

group :development do
  gem "thin"
  gem "nifty-generators"
  gem "capistrano"
end

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', " ~> 3.1.0"
  gem 'coffee-rails', " ~> 3.1.0"
  gem 'uglifier'
end
