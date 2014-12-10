class Group < ActiveRecord::Base
  belongs_to :user
  belongs_to :organization
  has_many   :member, class_name: 'Member::GroupMember'
end
