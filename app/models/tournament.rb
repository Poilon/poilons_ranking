class Tournament < ActiveRecord::Base
  belongs_to :game
  has_many :results, dependent: :destroy
  before_save :calculate_total_participants

  include FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]
  
  def slug_candidates
    [
      :name,
      [:name, :id],
    ]
  end

  def construct_results(raw)
    raw.lines.each do |line|
      rank = line.strip.scan(/^\d*/).first      
      name = line.gsub(/^\d*./, '').strip
      participant = Participant.find_by(name: name, game_id: game.id)
      unless name.blank?
        participant = Participant.create(name: name, game_id: game.id) unless participant
        Result.create(participant_id: participant.id, tournament_id: id, rank: rank)
        participant.compute_score
      end
    end
  end

  def compute_scores
    self.results.map { |r| r.participant.compute_score }
  end

  def to_raw
    self.results.order('rank asc').map { |result| "#{result.rank}. #{result.participant.name if result.participant}" }.join("\n")
  end

  def define_multiplier
    multiplier = 0
    self.results.each do |result|
      multiplier += result.participant.score / 10
    end
    multiplier + (results.count * 3)
  end

  def calculate_total_participants
    total_participants = results.count
  end
end