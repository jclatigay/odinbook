class FollowRequest < ApplicationRecord
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"

  validates :follower_id, uniqueness: { scope: :followed_id }

  enum :status, { pending: 0, accepted: 1, rejected: 2 }, default: :pending

  scope :pending, -> { where(status: :pending) }
  scope :accepted, -> { where(status: :accepted) }
  scope :rejected, -> { where(status: :rejected) }
end
