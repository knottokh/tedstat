class AddPrefixToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :prefix, :string
  end
end
