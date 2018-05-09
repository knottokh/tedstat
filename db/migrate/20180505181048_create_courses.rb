class CreateCourses < ActiveRecord::Migration[5.1]
  def change
    create_table :courses do |t|
      t.string :couse_code
      t.string :couse_name
      t.string :couse_year
      t.string :couse_detail
      
      t.timestamps
    end
  end
end
