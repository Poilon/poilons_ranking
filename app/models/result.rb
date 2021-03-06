class Result < ActiveRecord::Base
  belongs_to :tournament
  belongs_to :participant
  after_destroy :compute_participant_score

  def self.compute
    sum = 0
    scores = all.map(&:tournament_score)
    5.times do
      (i = scores.find_index(scores.max)) && sum += scores.delete_at(i) unless scores.blank?
    end
    (sum * 1000).round / 1000.to_f
  end

  def tournament_score
    tournament.multiplier.to_f / rank.to_f
  end

  private

  def compute_participant_score
    participant.compute_score if participant
  end
end
