class CreateTasks < ActiveRecord::Migration[5.1]
  def change
    create_table :tasks do |t|
      t.string    :task_name
      t.string    :task_detail
      t.string    :task_assessment
      t.string    :task_behavior
      t.text      :task_feedback
      t.datetime  :task_duedate
      t.datetime   :task_alert
      
      t.timestamps
    end
  end
end
