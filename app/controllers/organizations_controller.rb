class OrganizationsController < ApplicationController
  permits :name

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
end
