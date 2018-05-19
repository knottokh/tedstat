class AddRefrence < ActiveRecord::Migration[5.1]
  def change
      add_column :users, :name, :string
      add_column :users, :surname, :string
      add_column :users, :student_code, :string
      add_column :users, :role, :integer
      add_reference :users, :school, foreign_key: true
      add_column :users, :prefix, :string
      
      add_reference :courses, :user, foreign_key: true
      
      add_reference :rooms, :course, foreign_key: true
      add_column :rooms, :ratio_score, :text
      add_column :rooms, :ratio_grade, :text
      add_column :rooms, :point_attr, :integer
      
      add_reference :scourses, :room, foreign_key: true
      add_reference :scourses, :user, foreign_key: true
      add_reference :scourses, :course, foreign_key: true
      add_column :scourses, :average_score,     :float ,  :default => 0.0
      add_column :scourses, :grade,             :string
      add_column :scourses, :is_point_attr,     :bool ,  :default => false
      
      add_reference :tasks, :course, foreign_key: true
      add_reference :tasks, :room, foreign_key: true
      add_column :tasks,    :task_behavior_extra,  :text, :null => true
      add_column :tasks, :average_score,     :float,  :default => 0.0
      add_column :tasks,    :task_assignment_other,  :string
      
      add_reference :taskresults, :user, foreign_key: true
      add_reference :taskresults, :task, foreign_key: true
      
      add_reference :feedbacks, :task, foreign_key: true
      
      
  end
end
