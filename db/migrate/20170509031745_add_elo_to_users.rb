class AddEloToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :elo, :integer
  end
end
