class AddColumnstoScourse < ActiveRecord::Migration[5.1]
  def change
    add_column :scourses, :order,      :integer 
  end
end
