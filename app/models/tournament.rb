class Tournament < ActiveRecord::Base
  belongs_to :game
  has_many :results
end
