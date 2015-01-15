class Participant < ActiveRecord::Base
  has_many :results, dependent: :destroy
  belongs_to :game
  geocoded_by :location
  reverse_geocoded_by :latitude, :longitude do |obj, results|
    if geo = results.first
      obj.city = geo.city
      obj.state = geo.state
      obj.sub_state = geo.sub_state
      obj.country = geo.country
    end
  end
  after_validation :geocode, if: ->(obj){ obj.location.present? and obj.location_changed? }
  after_validation :reverse_geocode
  
  def compute_score
    self.update_attribute(:score, results.compute)
  end

  def global_rank
    Participant.where(game_id: game.id).where('score > ?', score).count + 1
  end

  def country_rank
    Participant.where(game_id: game.id).where('country = ? and score > ?', country, score).count + 1
  end

  def state_rank
    Participant.where(game_id: game.id).where('country = ? and state = ? and score > ?', country, state, score).count + 1
  end

  def sub_state_rank
    Participant.where(game_id: game.id).where('country = ? and sub_state = ? and state = ? and score > ?', country, sub_state, state, score).count + 1
  end

  def city_rank
    Participant.where(game_id: game.id).where('country = ? and sub_state = ? and state = ? and city = ? and score > ?', country, sub_state, state, city, score).count + 1
  end

  def self.clean
    where('id not in (select distinct(participant_id) FROM results)').map(&:destroy)
  end

  def merge_process
    if participant = Participant.find_by_name(self.name)
      results.each { |r| r.update_attribute(:participant_id, participant.id) }
      self.reload.destroy
      participant.compute_score
    end
  end
end
