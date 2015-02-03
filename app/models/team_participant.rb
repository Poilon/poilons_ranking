class TeamParticipant < ActiveRecord::Base
  belongs_to :team
  belongs_to :participant
  after_save :expire_cache
  after_create :expire_cache
  after_destroy :expire_cache

  def expire_cache
    Rails.cache.delete("#{participant.game.id}_participants")
  end
  
end
