class CreateTeamParticipants < ActiveRecord::Migration
  def change
    create_table :team_participants do |t|
      t.integer :team_id
      t.integer :participant_id
    end
  end
end
