class User < ActiveRecord::Base
  after_initialize :ensure_session_token
  attr_reader :password
  validates :email, uniqueness: true
  validates :password, length: {minimum: 6, allow_nil: true}
  validates :session_token, :email, presence: true
  has_many :subscriptions
  has_many :businesses, through: :subscriptions, source: :business
  
  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64(16)
  end
  
  def reset_session_token!
    self.session_token = SecureRandom.urlsafe_base64(16)
    self.save
    self.session_token
  end
  
  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end
  
  def is_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end
  
  def self.find_by_credentials(user_params)
    user = User.find_by(email: user_params[:email])
    return nil if user.nil?
    if user.is_password?(user_params[:password])
      return user
    else
      nil
    end
  end
  
  def subscribed_to?(business)
    subscriptions.exists?(business_id: business.id)
  end
end
