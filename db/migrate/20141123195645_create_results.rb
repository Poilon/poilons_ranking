class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.integer :participant_id
      t.integer :tournament_id
      t.integer :rank

      t.timestamps
    end
  end
end
