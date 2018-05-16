class CreateFeedbacks < ActiveRecord::Migration[5.1]
  def change
    create_table :feedbacks do |t|
      t.string    :feed_text
      
      t.timestamps
    end
    add_reference :feedbacks, :taskresult, foreign_key: true
    add_reference :feedbacks, :user, foreign_key: true
  end
end
