class Removealertandaddwithtype < ActiveRecord::Migration[5.1]
  def change
    remove_column :tasks, :task_alert
    add_column :tasks, :task_alert,     :datetime
  end
end
