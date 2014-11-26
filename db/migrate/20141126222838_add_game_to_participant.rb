class AddGameToParticipant < ActiveRecord::Migration
  def change
    add_reference :participants, :game, index: true
  end
end
