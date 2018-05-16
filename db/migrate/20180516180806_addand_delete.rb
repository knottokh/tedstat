class AddandDelete < ActiveRecord::Migration[5.1]
  def change
    remove_column :rooms, :attribute_point
    add_column :rooms, :point_attr, :integer
  end
end
