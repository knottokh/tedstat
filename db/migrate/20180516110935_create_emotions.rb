class CreateEmotions < ActiveRecord::Migration[5.1]
  def change
    create_table :emotions do |t|
      t.string    :emotion
      
      t.timestamps
    end
    add_reference :emotions, :course, foreign_key: true
    add_reference :emotions, :room, foreign_key: true
    add_reference :emotions, :user, foreign_key: true
  end
end
