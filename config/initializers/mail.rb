ActionMailer::Base.smtp_settings = {
  :address        => 'smtp.sendgrid.net',
  :port           => '587',
  :authentication => :plain,
  :user_name      => 'app9122002@heroku.com',
  :password       => 'db2vgdro',
  :domain         => 'heroku.com'
}
ActionMailer::Base.delivery_method = :smtp
