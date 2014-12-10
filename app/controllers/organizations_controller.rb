class OrganizationsController < ApplicationController
  permits :name

  before_action :set_organization

  # 一覧
  def index
    @organizations = Organization.all
    @organization  = Organization.new
  end

  # 作成
  def create(organization)
    @organization = Organization.new(organization)
    @organization.user_id = current_user.id
    @organization.save!

    redirect_to organizations_path and return
  end

  # メンバー一覧
  def members(id)
    @members = Member::OrganizationMember.where(organization_id: id)

    if @organization.invite_token.blank?
      @organization.update!(invite_token: SecureRandom.hex(16))
    end
  end

  # メンバー追加
  def add_member(id, invite_token)
    organization = Organization.find_by(id: id, invite_token: invite_token)

    redirect_to root_path, alert: '組織情報がありません。' and return if organization.blank?

    Member::OrganizationMember.where(organization_id: organization.id, user_id: current_user.id).first_or_create!

    redirect_to organization_schedules_path(organization) and return
  end

  # メンバー削除
  def delete_member(id, member_id)
    member = Member::OrganizationMember.find_by(id: member_id, organization_id: id)
    member.destroy!

    redirect_to members_organization_path(@organization) and return
  end

  private

  # 組織情報取得
  def set_organization
    @organization = Organization.find_by(id: params[:id])

    redirect_to root_path, alert: '組織情報がありません。' and return if @organization.blank?
  end
end
