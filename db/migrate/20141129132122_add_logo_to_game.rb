class AddLogoToGame < ActiveRecord::Migration
  def change
    add_column :games, :logo, :string
  end
end
