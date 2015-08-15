class User < ActiveRecord::Base
  has_and_belongs_to_many :leagues

  has_secure_password

  # ----------------------- Callbacks --------------------

  before_create :generate_token

  #after_create :send_welcome_email

  # ----------------------- Validations --------------------

  validates :email,
            :format => { :with => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i },
            length: { in: 6..30 },
            presence: true,
            uniqueness: true

  validates :username,
            :length => { :in => 4..20 },
            presence: true,
            uniqueness: true

  validates :password,
            :length => { :in => 8..24 },
            :allow_nil => true

  # ----------------------- Methods --------------------

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

  def self.send_welcome_email(id)
    user = User.find(id)
    UserMailer.welcome(user).deliver
  end

  def self.notify_about_results(user_id, league_id)
    user = User.find(user_id)
    UserMailer.notify(user, league_id).deliver
  end

  def send_welcome_email
    User.send_welcome_email(self.id)
  end

end
