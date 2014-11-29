class AddLatitudeAndLongitudeToParticipant < ActiveRecord::Migration
  def change
    add_column :participants, :location, :string
    add_column :participants, :latitude, :float
    add_column :participants, :longitude, :float
    add_column :participants, :country, :string
    add_column :participants, :state, :string
    add_column :participants, :sub_state, :string
    add_column :participants, :city, :string
  end
end
