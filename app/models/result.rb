class Result < ActiveRecord::Base
  has_one :tournament
  has_one :participant
end
