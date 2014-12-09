class OrganizationsController < ApplicationController
  permits :name

  # 一覧
  def index
    @organizations = Organization.all
    @organization  = Organization.new
  end
end
