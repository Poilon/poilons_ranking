class Result < ActiveRecord::Base
  belongs_to :tournament
  belongs_to :participant

  def self.compute
    map(&:tournament_score).sum
  end
  
  def tournament_score
    result.tournament.multiplier.to_f / result.rank.to_f
  end
end
