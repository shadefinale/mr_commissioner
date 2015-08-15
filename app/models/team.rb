class Team < ActiveRecord::Base
  has_many :player_scores
  belongs_to :league

  def weekly_scores(week, season=2014)
    self.player_scores.where(:week_id => get_week_id(week, season)).sum(:points)
  end

  def get_week_id(week, season)
    Week.find_by(:number => week, :year => season).id
  end

  def best_week(season=2014)
    score = self.get_all_scores(season).transpose[0].max
    week = self.get_all_scores(season).transpose[0].index(score) + 1
    [score, week]
  end

  def worst_week(season=2014)
    score = self.get_all_scores(season).transpose[0].min
    week = self.get_all_scores(season).transpose[0].index(score) + 1
    [score, week]
  end

  def get_all_scores(season=2014)
    all_scores = []
    matchup_count.times do |n|
      all_scores << [self.weekly_scores(n+1, season), n+1]
    end
    all_scores
  end

  def matchup_count(season = 2014)
    self.league.roster_counts.find_by(year: season).matchup_count
  end

  def season_total(season=2014)
    self.get_all_scores(season).transpose[0].sum
  end

  def all_play_by_week_wins(week, season=2014)
    wins = 0
    self.league.teams.each do |t|
      wins += 1 if t.weekly_scores(week) < self.weekly_scores(week)
    end
    wins
  end

  def all_play_by_season_wins(season=2014)
    wins = 0
    matchup_count.times do |w|
      wins += all_play_by_week_wins(w + 1, season)
    end
    wins
  end

  def all_play_by_week_losses(week, season=2014)
    losses = 0
    self.league.teams.each do |t|
      losses += 1 if t.weekly_scores(week) > self.weekly_scores(week)
    end
    losses
  end

  def all_play_by_season_losses(season=2014)
    losses = 0
    matchup_count.times do |w|
      losses += all_play_by_week_losses(w + 1, season)
    end
    losses
  end

  def all_play_by_week_record(week, season=2014)
    wins = all_play_by_week_wins(week, season)
    losses = all_play_by_week_losses(week, season)
    ties = (self.league.teams.count-1) - (wins + losses)
    "#{wins}-#{losses}-#{ties}"
  end

  def all_play_by_season_record(season=2014)
    wins = all_play_by_season_wins(season)
    losses = all_play_by_season_losses(season)
    ties = ((self.league.teams.count-1) * (self.league.roster_counts.first.matchup_count)) - (wins + losses)
    "#{wins}-#{losses}-#{ties}"
  end

  def all_play_by_week_percentage(week, season=2014)
    (all_play_by_week_wins(week, season).to_f / (self.league.teams.count - 1)).round(3)
  end

  def all_play_by_season_percentage(season=2014)
    (all_play_by_season_wins(season).to_f / ((self.league.teams.count - 1) * self.league.roster_counts.first.matchup_count)).round(3)
  end


end
