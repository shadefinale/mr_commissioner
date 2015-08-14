class PlayerScore < ActiveRecord::Base
  belongs_to :player
  belongs_to :week
  belongs_to :team

  def league
    self.team.league
  end
end
