class AddLogoToGame < ActiveRecord::Migration
  def change
    add_attachment :games, :logo
  end
end
