class AddSlugToParticipants < ActiveRecord::Migration
  def change
    add_column :participants, :slug, :string
  end
end
