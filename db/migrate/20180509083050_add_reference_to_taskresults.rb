class AddReferenceToTaskresults < ActiveRecord::Migration[5.1]
  def change
    add_reference :taskresults, :user, foreign_key: true
    add_reference :taskresults, :task, foreign_key: true
  end
end
