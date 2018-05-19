class AddAndCreateto < ActiveRecord::Migration[5.1]
  def change
    add_column :scourses, :is_point_attr,     :bool ,  :default => false
  end
end
