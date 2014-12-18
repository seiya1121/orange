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
  def edit(id)
    @group = Group.find_by(id: id)
  end

  # 更新
  def update(id, group)
    @group = Group.find_by(id: id)
    @group.update!(group.permit!)

    redirect_to organization_groups_path(@group.organization_id) and return
  end
end
