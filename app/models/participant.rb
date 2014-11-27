class Participant < ActiveRecord::Base
  has_many :results
  belongs_to :game

  def compute_score
    self.update_attribute(:score, results.compute)
  end
end
