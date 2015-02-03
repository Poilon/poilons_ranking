class AddGameIdAndSlugToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :game_id, :integer
    add_column :teams, :slug, :string
  end
end
