class AddColumnstoScourse2 < ActiveRecord::Migration[5.1]
  def change
    remove_column :scourses, :order
    add_column :scourses, :studenno,      :integer 
  end
end
