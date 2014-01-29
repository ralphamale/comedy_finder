class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name
      t.integer :online_id
      t.date :start_date
      t.string :teacher
      t.integer :avail_slots

      t.timestamps
    end
  end
end
