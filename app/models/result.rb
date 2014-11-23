class Result < ActiveRecord::Base
  belongs_to :tournament
  belongs_to :participant
end
