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
end
