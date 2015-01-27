class CharacterParticipant < ActiveRecord::Base
  belongs_to :participant
  belongs_to :character
end
