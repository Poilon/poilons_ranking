class AddGameIdToAlternateNickname < ActiveRecord::Migration
  def change
    add_column :alternate_nicknames, :game_id, :integer
  end
end
