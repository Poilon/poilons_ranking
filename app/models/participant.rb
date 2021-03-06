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
  after_validation :update_indexes

  has_many :character_participants, dependent: :destroy
  has_many :characters, through: :character_participants

  has_many :team_participants, dependent: :destroy
  has_many :teams, through: :team_participants

  include FriendlyId
  friendly_id :slug_candidates, use: [:slugged, :finders]
  
  def slug_candidates
    [
      :name,
      [:name, :city],
      [:name, :id],
    ]
  end

  def twitter_link
    twitter_id = twitter
    if twitter_id
      twitter_id = twitter_id[1..-1] if twitter_id.first == '@'
      "http://www.twitter.com/#{twitter_id}"
    end
  end

  def compute_score
    self.update_attribute(:score, results.compute)
  end

  def global_rank
    game_participants.ranking(score)
  end

  def country_rank
    game_participants.from_country(country).ranking(score)
  end

  def state_rank
    game_participants.from_state(country, state).ranking(score)
  end

  def sub_state_rank
    game_participants.from_sub_state(country, state, sub_state).ranking(score)
  end

  def city_rank
    game_participants.from_city(country, state, sub_state, city).ranking(score)
  end

  def character_rank(character_name)
    character = Character.where(game_id: game.id).find_by_slug(character_name)
    character ? character.participants.ranking(score) : global_rank
  end

  def next_target
    game_participants.where('score > ?', score).order('score asc').first if location
  end

  def training_partners
    return city_buddies      if city      && city_buddies.count      > 0
    return sub_state_buddies if sub_state && sub_state_buddies.count > 0
    return state_buddies     if state     && state_buddies.count     > 0
    return country_buddies   if country   && country_buddies.count   > 0
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

  def self.ranking(score)
    where('score > ?', score).count + 1
  end

  def character_names
    characters.pluck(:slug).join("\n")
  end

  def team_names
    teams.pluck(:name).join("\n")
  end

  def country_code
    CountryCodesList.mapping(country)
  end

  private

  def city_buddies
    game_participants.from_city(country, state, sub_state, city).get_close_buddies(id, score)
  end

  def sub_state_buddies
    game_participants.from_sub_state(country, state, sub_state).get_close_buddies(id, score)
  end
  
  def state_buddies
    game_participants.from_state(country, state).get_close_buddies(id, score)
  end
  
  def country_buddies
    game_participants.from_country(country).get_close_buddies(id, score)
  end

  def world_buddies
    game_participants.get_close_buddies(id, score)
  end

  def self.from_city(country, state, sub_state, city)
    where(country: country, state: state, sub_state: sub_state, city: city)
  end

  def self.from_sub_state(country, state, sub_state)
    where(country: country, state: state, sub_state: sub_state)
  end

  def self.from_state(country, state)
    where(country: country, state: state)
  end

  def self.from_country(country)
    where(country: country)
  end

  def self.get_close_buddies(id, score)
    ordered_collection = self.order('score desc')
    better = ordered_collection.where('score > ?', score).last(2)
    tie = ordered_collection.where('id <> ? and score = ?', id, score).sample(2)
    worst = ordered_collection.where('score < ?', score).first(2)
    tie + better + worst
  end

  def self.filter_by_params(params)
    game = Game.find(params[:game_id])
    participants = Participant.where(game_id: game.id)

    if (character = game.characters.find_by_slug(params[:character]))
      participants = participants.joins(:characters).where(characters: {id: character.id})
      participants = participants.joins(:character_participants).where(character_participants: {rank: 1}).uniq if params[:main]
    end
    if params[:country] == 'Europe'
      participants = participants.where(country: CountryCodesList.europe) if params[:country] == 'Europe'
    else
      participants = participants.where(country: params[:country]) if params[:country]
      participants = participants.where(state: params[:state]) if params[:state]
      participants = participants.where(sub_state: params[:sub_state]) if params[:sub_state]
      participants = participants.where(city: params[:city]) if params[:city]
    end
    if (team = game.teams.find_by_slug(params[:team]))
      participants = participants.joins(:teams).where(teams: {id: team.id})
    end
    participants
  end

  def game_participants
    Participant.where(game_id: game.id)
  end

  def update_indexes
    self.update_attribute(:characters_index, self.character_names.gsub("\n", ','))
    self.update_attribute(:teams_index, self.teams.map{ |c| c.slug + ';' + c.name }.join(','))
  end
end
