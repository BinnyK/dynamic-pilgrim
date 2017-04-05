class AddFieldsToGame < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :winner_name, :string
    add_column :games, :winner_score, :integer, default: 3
    add_column :games, :loser_name, :string
    add_column :games, :loser_score, :integer, default: 0
  end
end
