class GroupsController < ApplicationController
  permits :name

  # 一覧
  def index(organization_id)
    @organization = Organization.find_by(id: organization_id)
    @groups       = Group.where(organization_id: organization_id).order(created_at: :asc)
    @group        = Group.new
  end

  # 作成
  def create(organization_id, group)
    @group = Group.new(group)
    @group.user_id         = current_user.id
    @group.organization_id = organization_id
    @group.save!

    redirect_to organization_groups_path(organization_id) and return
  end

  # 編集
  def edit(organization_id, id)
    @group        = Group.find_by(id: id)
    @organization = Organization.find_by(id: organization_id)
    @group_members        = Member::GroupMember.where(organization_id: organization_id, group_id: id).order(created_at: :asc)
    @organization_members = Member::OrganizationMember.where(organization_id: organization_id).where.not(user_id: @group_members.pluck(:user_id)).order(created_at: :asc)
  end

  # 更新
  def update(organization_id, id, group)
    @group = Group.find_by(id: id)
    @group.update!(group.permit!)

    redirect_to organization_groups_path(@group.organization_id) and return
  end

  # メンバー追加
  def add_member(organization_id, group_id, user_id)
    Member::GroupMember.where(organization_id: organization_id, group_id: group_id, user_id: user_id).first_or_create!

    redirect_to edit_organization_group_path(organization_id, group_id) and return
  end

  # メンバー削除
  def delete_member(organization_id, group_id, user_id)
    member = Member::GroupMember.find_by(organization_id: organization_id, group_id: group_id, user_id: user_id)
    member.destroy!

    redirect_to edit_organization_group_path(organization_id, group_id) and return
  end
end
