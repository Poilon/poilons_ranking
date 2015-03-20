class Game < ActiveRecord::Base
  has_many :tournaments, dependent: :destroy
  has_many :participants, dependent: :destroy
  has_many :characters, dependent: :destroy
  has_many :teams, dependent: :destroy

  include FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]
  
  def slug_candidates
    [
      :name,
      [:name, :id],
    ]
  end

  def compute
    Participant.clean
    participants.map(&:compute_score)
  end
end
