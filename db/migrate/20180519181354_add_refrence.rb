class AddRefrence < ActiveRecord::Migration[5.1]
  def change
    add_reference :feedbacks, :task, foreign_key: true
  end
end
