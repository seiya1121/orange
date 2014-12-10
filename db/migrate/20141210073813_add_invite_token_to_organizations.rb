class AddInviteTokenToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :invite_token, :string
  end
end
