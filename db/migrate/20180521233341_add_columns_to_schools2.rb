class AddColumnsToSchools2 < ActiveRecord::Migration[5.1]
  def change
    remove_column :scourses, :education_area
    remove_column :scourses, :ministry_code
    remove_column :scourses, :municipal_area
    remove_column :scourses, :district
    remove_column :scourses, :province
    remove_column :scourses, :postcode
    remove_column :scourses, :zone
    remove_column :scourses, :students_count
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
