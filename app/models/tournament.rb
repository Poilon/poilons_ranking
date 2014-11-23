class Tournament < ActiveRecord::Base
  has_one :game
  has_many :results
end
