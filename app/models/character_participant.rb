class CharacterParticipant < ActiveRecord::Base
  belongs_to :participant
  belongs_to :character
  after_save :expire_cache
  after_create :expire_cache
  after_destroy :expire_cache

  def expire_cache
    Rails.cache.delete("#{participant.game.id}_participants")
  end
  
end
