class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  validates :password_confirmation, presence: true

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :follow_requests_sent, class_name: "FollowRequest", foreign_key: "follower_id", dependent: :destroy
  has_many :follow_requests_received, class_name: "FollowRequest", foreign_key: "followed_id", dependent: :destroy

  has_many :following, through: :follow_requests_sent, source: :followed
  has_many :followers, through: :follow_requests_received, source: :follower
end
