class Game < ActiveRecord::Base
  has_many :tournaments, dependent: :destroy
  has_many :participants, dependent: :destroy

  include FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]
  
  def slug_candidates
    [
      :name,
      [:name, :id],
    ]
  end
end
