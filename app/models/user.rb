class User < ActiveRecord::Base
  
  # :token_authenticatable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :lockable
   
  attr_accessible :name, :email, :password, :password_confirmation, :remember_me, :site_url, :email_on_reply
  
  before_create { generate_token(:token) }
  has_many :comments
  has_many :episodes 
  has_paper_trail
  
  after_save :update_name 
  
  def update_name 
    if self.name.present? 
        return 
    else 
        self.update_attribute(:name, self.email.split('@').first) 
    end 
  end 

  def self.create_from_omniauth(omniauth)
    User.new.tap do |user|
      user.github_uid = omniauth["uid"]
      user.github_username = omniauth["user_info"]["nickname"]
      user.email = omniauth["user_info"]["email"]
      user.name = omniauth["user_info"]["name"]
      user.site_url = omniauth["user_info"]["urls"]["Blog"] if omniauth["user_info"]["urls"]
      user.gravatar_token = omniauth["extra"]["user_hash"]["gravatar_id"] if omniauth["extra"] && omniauth["extra"]["user_hash"]
      user.email_on_reply = true
      user.save!
    end
  end

  def generated_unsubscribe_token
    if unsubscribe_token.blank?
      generate_token(:unsubscribe_token)
      save!
    end
    unsubscribe_token
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def display_name
    self.name
  end

  def banned?
    banned_at
  end
end
