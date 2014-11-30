class AddLogoToGame < ActiveRecord::Migration
  def change
    add_column :games, :logo_url, :string
  end
end
