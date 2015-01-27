class Character < ActiveRecord::Base
  has_many :character_participants
  has_many :participants, through: :character_participants
  belongs_to :game
end