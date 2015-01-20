class AddWikiToParticipant < ActiveRecord::Migration
  def change
    add_column :participants, :wiki, :string
  end
end
