class User < ActiveRecord::Base
	
	before_save { email.downcase! }
	has_secure_password
	before_save :create_remember_token
    validates :name, presence: true, length: {maximum: 50}
    validates :email, presence: true
    validates :password, length: {minimum: 6}
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates :email, presence:   true,
                   format:     { with: VALID_EMAIL_REGEX },
                   uniqueness: { case_sensitive: false }
    private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
