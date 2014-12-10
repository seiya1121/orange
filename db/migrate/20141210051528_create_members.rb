class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.references :user, index: true
      t.references :organization, index: true
      t.references :group, index: true
      t.string :type

      t.timestamps
    end
  end
end
