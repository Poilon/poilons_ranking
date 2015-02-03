class Character < ActiveRecord::Base
  has_many :character_participants, dependent: :destroy
  has_many :participants, through: :character_participants
  belongs_to :game
  after_save :expire_cache
  after_destroy :expire_cache

  def expire_cache
    Rails.cache.delete("#{game.id}_participants")
  end
end