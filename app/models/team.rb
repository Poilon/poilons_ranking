class Team < ActiveRecord::Base
  has_many :team_participants, dependent: :destroy
  has_many :participants, through: :team_participants
  belongs_to :game
  after_save :expire_cache
  after_destroy :expire_cache

  def expire_cache
    Rails.cache.delete("#{game.id}_participants")
  end
  
  include FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]
  
  def slug_candidates
    [
      :name,
      [:name, :id]
    ]
  end
end
