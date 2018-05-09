class CreateTaskresults < ActiveRecord::Migration[5.1]
  def change
    create_table :taskresults do |t|
      t.string    :score
      t.string    :quality
      t.string    :advantage
      t.string    :disadvantage
      t.text      :suggestion
      t.text      :remark
      
      t.timestamps
    end
  end
end
