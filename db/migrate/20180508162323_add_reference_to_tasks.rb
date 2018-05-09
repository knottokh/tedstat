class AddReferenceToTasks < ActiveRecord::Migration[5.1]
  def change
    add_reference :tasks, :course, foreign_key: true
    add_reference :tasks, :room, foreign_key: true
  end
end
