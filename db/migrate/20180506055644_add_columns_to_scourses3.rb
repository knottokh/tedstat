class AddColumnsToScourses3 < ActiveRecord::Migration[5.1]
  def change
    add_reference :scourses, :user, foreign_key: true
    remove_column :rooms, :user_id
  end
end
