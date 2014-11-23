class AddMultiplierToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :multiplier, :integer
  end
end
