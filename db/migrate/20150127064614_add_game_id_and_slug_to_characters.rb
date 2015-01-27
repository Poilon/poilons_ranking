class AddGameIdAndSlugToCharacters < ActiveRecord::Migration
  def change
    add_column :characters, :game_id, :integer
    add_column :characters, :slug, :string
  end
end
