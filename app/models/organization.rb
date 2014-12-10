class Organization < ActiveRecord::Base
  belongs_to :user
  has_many   :groups
  has_many   :member, class_name: 'Member::OrganizationMember'

  scope :belong, -> (user) { where(organizations: { id: user.members.pluck(:organization_id) }) }

  after_create { |organization| Member::OrganizationMember.create(organization_id: organization.id, user_id: organization.user_id) }

  def owner?(user)
    self.user_id == user.try(:id)
  end
end
