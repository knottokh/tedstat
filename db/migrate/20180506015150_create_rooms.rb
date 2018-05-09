class CreateRooms < ActiveRecord::Migration[5.1]
  def change
    create_table :rooms do |t|
      t.string :room_name
      t.string :room_detail
      t.string :room_pin
      
      t.timestamps
    end
  end
end
