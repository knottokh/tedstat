class AddColumnsToRooms < ActiveRecord::Migration[5.1]
  def change
      add_column :rooms, :attribute_point, :integer
      add_column :rooms, :ratio_score, :text
      add_column :rooms, :ratio_grade, :text
  end
end
