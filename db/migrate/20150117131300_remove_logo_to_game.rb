class RemoveLogoToGame < ActiveRecord::Migration
  def change
    remove_column :games, :logo, :string
  end
end
