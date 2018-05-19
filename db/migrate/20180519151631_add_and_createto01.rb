class AddAndCreateto01 < ActiveRecord::Migration[5.1]
  def change
    add_column :tasks,    :task_assignment_other,  :string
  end
end
