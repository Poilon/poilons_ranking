class AddTwitterAndYoutubeToParticipants < ActiveRecord::Migration
  def change
    add_column :participants, :twitter, :string
    add_column :participants, :youtube, :string
  end
end
