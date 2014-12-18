class Group < ActiveRecord::Base
  ## アソシエーション
  belongs_to :user
  belongs_to :organization
  has_many   :member, class_name: 'Member::GroupMember'
  has_many   :participations
  has_many   :schedules, through: :participations

  ## バリデーション
  validates :name, presence: true
end
