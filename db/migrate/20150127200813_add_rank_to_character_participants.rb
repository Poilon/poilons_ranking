class AddRankToCharacterParticipants < ActiveRecord::Migration
  def change
    add_column :character_participants, :rank, :integer
  end
end
