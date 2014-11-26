class Participant < ActiveRecord::Base
  has_many :results
  belongs_to :game
end
