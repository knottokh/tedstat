class AddColumnsToSchools2 < ActiveRecord::Migration[5.1]
  def change
    add_column :schools, :education_area,      :string 
    add_column :schools, :ministry_code,       :string 
    add_column :schools, :municipal_area,      :string 
    add_column :schools, :district,            :string 
    add_column :schools, :province,            :string 
    add_column :schools, :postcode,            :string 
    add_column :schools, :zone,                :integer 
    add_column :schools, :students_count,      :integer 
  end
end
