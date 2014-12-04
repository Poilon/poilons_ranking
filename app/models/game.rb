class Game < ActiveRecord::Base
  has_many :tournaments, dependent: :destroy
  has_many :participants, dependent: :destroy

  mount_uploader :logo, LogoUploader
end
