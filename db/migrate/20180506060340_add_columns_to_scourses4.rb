class AddColumnsToScourses4 < ActiveRecord::Migration[5.1]
  def change
    add_reference :scourses, :course, foreign_key: true
  end
end
