class CreateScourses < ActiveRecord::Migration[5.1]
  def change
    create_table :scourses do |t|
      t.string :status
      
      t.timestamps
    end
  end
end
