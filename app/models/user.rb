class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [ :github ]

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  validates :password_confirmation, presence: true

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :follow_requests_sent, class_name: "FollowRequest", foreign_key: "follower_id", dependent: :destroy
  has_many :follow_requests_received, class_name: "FollowRequest", foreign_key: "followed_id", dependent: :destroy

  has_many :following,
           through: :follow_requests_sent,
           source: :followed do
             def accepted
               merge(FollowRequest.accepted)
             end
           end

  has_many :followers,
           through: :follow_requests_received,
           source: :follower do
             def accepted
               merge(FollowRequest.accepted)
             end
           end

  AVATAR_OPTIONS = {
    "Monster" => "monsterid",
    "Identicon" => "identicon",
    "Wavatar" => "wavatar",
    "Retro" => "retro",
    "Robot" => "robohash"
  }

  def gravatar_url(size: 80, default: self.default_avatar || "mp", rating: "pg")
    gravatar_id = Digest::MD5.hexdigest(email.downcase)
    "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}&d=#{default}&r=#{rating}"
  end

  after_create :send_welcome_email

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.password_confirmation = user.password
      user.default_avatar = "retro"
    end
  end

  private

  def send_welcome_email
    UserMailer.welcome_email(self).deliver_now
  end
end
