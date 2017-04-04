class AddColumnsToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :wins, :integer
    add_column :users, :losses, :integer
    add_column :users, :points, :integer
  end
end
