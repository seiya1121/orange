class CreateParticipations < ActiveRecord::Migration
  def change
    create_table :participations do |t|
      t.references :schedule, index: true
      t.references :group, index: true
      t.references :organization, index: true

      t.timestamps
    end
  end
end
