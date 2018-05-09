class AddColumnsToUsers < ActiveRecord::Migration[5.1]
  def change
      add_column :users, :name, :string
      add_column :users, :surname, :string
      add_column :users, :student_code, :string
      add_column :users, :role, :integer
      add_reference :users, :school, foreign_key: true
  end
end
