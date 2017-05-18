class AddFieldsToGames < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :winner_id, :integer
    add_column :games, :loser_id, :integer
  end
end
