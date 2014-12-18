class Group < ActiveRecord::Base
  ## アソシエーション
  belongs_to :user
  belongs_to :organization
  has_many   :member, class_name: 'Member::GroupMember'
  has_many   :participations
  has_many   :schedules, through: :participations

  ## バリデーション
  validates :name, presence: true

  ## コールバック
  after_create { |group| Member::GroupMember.create(organization_id: group.organization_id, group_id: group.id, user_id: group.user_id) }

  # メンバー追加済みか
  def added?(org_member)
    Member::GroupMember.where(organization_id: org_member.organization_id, group_id: self.id, user_id: org_member.user_id).exists?
  end
end
