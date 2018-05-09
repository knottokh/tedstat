class AddCouseToRoom < ActiveRecord::Migration[5.1]
  def change
    add_reference :rooms, :course, foreign_key: true
  end
end
