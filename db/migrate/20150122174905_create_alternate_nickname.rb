class CreateAlternateNickname < ActiveRecord::Migration
  def change
    create_table :alternate_nicknames do |t|
      t.integer :participant_id
      t.string :name
    end
  end
end
