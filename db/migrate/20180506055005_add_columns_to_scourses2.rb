class AddColumnsToScourses2 < ActiveRecord::Migration[5.1]
  def change
    add_reference :scourses, :user, foreign_key: true
  end
end
