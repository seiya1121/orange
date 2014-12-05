class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.references :user, index: true
      t.references :organization, index: true
      t.references :group, index: true
      t.references :repeat_setting, index: true
      t.string :title
      t.text :note
      t.timestamp :start_at
      t.timestamp :end_at

      t.timestamps
    end
  end
end
