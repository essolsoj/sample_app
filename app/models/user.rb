# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#

class User < ActiveRecord::Base
  
  attr_accessible :name, :email, :password, :password_confirmation
  #adds :password and :password_confirmation attributes
  #requires presence of password
  #require that password matches password_confirmation
  #adds an authenticate method to compare an encrypted password
  #in the password_digest field to authenticate users 
  has_secure_password
  
  #before_save { |user| user.email = email.downcase }
  before_save { email.downcase! } #symbol refers to the user instance
  before_save :create_remember_token
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true, length: { minimum: 6 }                    
  validates :password_confirmation, presence: true

  #accessible only internally from this class
    private
    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
