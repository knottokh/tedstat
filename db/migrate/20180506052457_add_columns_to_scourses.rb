class AddColumnsToScourses < ActiveRecord::Migration[5.1]
  def change
     add_reference :scourses, :room, foreign_key: true
  end
end
