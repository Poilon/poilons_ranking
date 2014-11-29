class AddRemoteIdToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :remote_id, :integer
  end
end
