class Tournament < ActiveRecord::Base
  belongs_to :game
  has_many :results, dependent: :destroy

  def construct_results(raw)
    raw.lines.each do |line|
      rank = line.strip.scan(/^\d*/).first      
      name = line.gsub(/^\d*./, '').strip
      participant = Participant.find_by(name: name, game_id: game.id)
      participant = Participant.create(name: name, game_id: game.id) unless participant
      Result.create(participant_id: participant.id, tournament_id: id, rank: rank)
    end
  end

  def to_raw
    self.results.order('rank asc').map { |result| "#{result.rank}. #{result.participant.name}" }.join("\n")
  end

  def define_multiplier
    multiplier = 0
    self.results.each do |result|
      multiplier += result.participant.score / 10
    end
    multiplier + (results.count * 3)
  end
end