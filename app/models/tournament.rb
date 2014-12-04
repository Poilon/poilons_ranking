class Tournament < ActiveRecord::Base
  belongs_to :game
  has_many :results, dependent: :destroy

  def construct_results(raw)
    raw.lines.each do |line|
      splitted_line = line.tr('.#:,=/\\', '       ').split(' ')
      rank = splitted_line.shift.to_i
      name = splitted_line.join(' ')
      participant = Participant.find_by(name: name, game_id: game.id)
      participant = Participant.create(name: name, game_id: game.id) unless participant
      Result.create(participant_id: participant.id, tournament_id: id, rank: rank)
    end
  end
end
