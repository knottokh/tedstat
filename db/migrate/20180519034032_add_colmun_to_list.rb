class AddColmunToList < ActiveRecord::Migration[5.1]
  def change
    add_column :tasks,    :task_behavior_extra,  :string
    add_column :scourses, :average_score,     :float ,  :default => 0.0
    add_column :scourses, :grade,             :string
    add_column :tasks, :average_score,     :float,  :default => 0.0
  end
end
