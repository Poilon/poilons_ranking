class Result < ActiveRecord::Base
  belongs_to :tournament
  belongs_to :participant

  def self.compute
    (all.map(&:tournament_score).sum * 1000).round / 1000.to_f
  end

  def tournament_score
    tournament.multiplier.to_f / rank.to_f
  end
end
