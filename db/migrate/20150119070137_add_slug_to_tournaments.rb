class AddSlugToTournaments < ActiveRecord::Migration
  def change
    add_column :tournaments, :slug, :string
  end
end
