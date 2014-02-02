class User < ActiveRecord::Base
	
	before_save { email.downcase! }
	has_secure_password
	before_save :create_remember_token
    validates :name, presence: true, length: {maximum: 50}
    validates :email, presence: true
    validates :password, length: {minimum: 6}

    private

    def create_remember_token
      self.remember_token = SecureRandom.urlsafe_base64
    end
end
