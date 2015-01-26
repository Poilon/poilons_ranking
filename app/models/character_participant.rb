class CharacterParticipant < ActiveRecord::Base
  has_one :participant
  has_one :character
end
