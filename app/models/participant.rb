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
    game_participants.where('score > ?', score).count + 1
  end

  def country_rank
    game_participants.where('country = ? and score > ?', country, score).count + 1
  end

  def state_rank
    game_participants.where('country = ? and state = ? and score > ?', country, state, score).count + 1
  end

  def sub_state_rank
    game_participants.where('country = ? and sub_state = ? and state = ? and score > ?', country, sub_state, state, score).count + 1
  end

  def city_rank
    game_participants.where('country = ? and sub_state = ? and state = ? and city = ? and score > ?', country, sub_state, state, city, score).count + 1
  end

  def next_target
    if location
      game_participants.where('score > ?', score).order('score asc').first
    end
  end

  def training_partners
    return city_buddies if city && city_buddies.count > 0
    return sub_state_buddies if sub_state && sub_state_buddies > 0
    return state_buddies if state && state_buddies > 0
    return country_buddies if country && country_buddies > 0
    return world_buddies
  end

  def self.clean
    where('id not in (select distinct(participant_id) FROM results)').map(&:destroy)
  end

  def merge_process
    if participant = game_participants.find_by_name(self.name)
      results.each { |r| r.update_attribute(:participant_id, participant.id) }
      self.reload.destroy
      participant.compute_score
    end
  end

  private

  def city_buddies
    city_players = game_participants.where('country = ? and sub_state = ? and state = ? and city = ?', country, sub_state, state, city).order('score desc')
    better = city_players.where('score > ?', score).last(2)
    tie = city_players.where('name <> ? and score = ?', name, score).sample(2)
    worst = city_players.where('score < ?', score).first(2)

    tie + better + worst
  end

  def sub_state_buddies
    players = game_participants.where('country = ? and sub_state = ? and state = ?', country, sub_state, state).order('score desc')
    better = players.where('score > ?', score).last(2)
    tie = players.where('name <> ? and score = ?', name, score).sample(2)
    worst = players.where('score < ?', score).first(2)

    tie + better + worst
  end
  
  def state_buddies
    players = game_participants.where('country = ? and state = ?', country, state).order('score desc')
    better = players.where('score > ?', score).last(2)
    tie = players.where('name <> ? and score = ?', name, score).sample(2)
    worst = players.where('score < ?', score).first(2)

    tie + better + worst
  end
  
  def country_buddies
    players = game_participants.where('country = ?', country).order('score desc')
    better = players.where('score > ?', score).last(2)
    tie = players.where('name <> ? and score = ?', name, score).sample(2)
    worst = players.where('score < ?', score).first(2)

    tie + better + worst
  end

  def world_buddies
    players = game_participants.order('score desc')
    better = players.where('score > ?', score).last(2)
    tie = players.where('name <> ? and score = ?', name, score).sample(2)
    worst = players.where('score < ?', score).first(2)

    tie + better + worst
  end

  def game_participants
    Participant.where(game_id: game.id)
  end
end
