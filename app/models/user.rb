class User < ActiveRecord::Base

  has_secure_password

  before_create :generate_token

  validates :username,
            :length => { :in => 4..20 },
            presence: true,
            uniqueness: true

  validates :password,
            :length => { :in => 8..24 },
            :allow_nil => true

  def generate_token
    begin
      self[:auth_token] = SecureRandom.urlsafe_base64
    end while User.exists?(auth_token: self[:auth_token]) # No repeat tokens among users. Reflects database unique constraint
  end

  def regenerate_auth_token
    self.auth_token = nil
    generate_token
    save!
  end

end
