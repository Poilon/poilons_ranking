class AddDateToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :date, :datetime
  end
end
