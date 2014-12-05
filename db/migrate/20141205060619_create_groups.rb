class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.references :user, index: true
      t.references :organization, index: true
      t.string :name

      t.timestamps
    end
  end
end
