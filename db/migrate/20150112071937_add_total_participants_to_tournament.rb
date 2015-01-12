class AddTotalParticipantsToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :total_participants, :integer
  end
end
