class AddCharactersIndexAndTeamsIndexToParticipant < ActiveRecord::Migration
  def change
    add_column :participants, :characters_index, :string
    add_column :participants, :teams_index, :string
  end
end
