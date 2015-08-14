class Team < ActiveRecord::Base
  has_many :player_scores
  belongs_to :league
end
