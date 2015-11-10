class Player < ActiveRecord::Base
  has_many :player_scores

  def season_total(league_id, season = 2015)
    sum = 0
    player_scores.each do |p|
      sum += p.points if p.season == 2015 && p.league.id == league_id
    end
    sum
  end
end
