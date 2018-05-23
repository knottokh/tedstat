class AddColumnstoScourse2 < ActiveRecord::Migration[5.1]
  def change
    add_column :scourses, :studenno,      :integer 
  end
end
