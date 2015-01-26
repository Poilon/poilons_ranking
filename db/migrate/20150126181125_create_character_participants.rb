class CreateCharacterParticipants < ActiveRecord::Migration
  def change
    create_table :character_participants do |t|
      t.integer :participant_id
      t.integer :character_id
    end
  end
end
