class AddScoreToParticipant < ActiveRecord::Migration
  def change
    add_column :participants, :score, :float
  end
end
