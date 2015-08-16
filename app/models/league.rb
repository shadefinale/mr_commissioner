class League < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :teams
  has_many :roster_counts


  def team_count
    self.teams.count
  end

  def best_all_play_record(season = 2014)
    current_best = 0
    best_team = nil

    teams.each do |team|
      percentage = team.all_play_by_season_percentage
      if percentage > current_best
        current_best = percentage
        best_team = team
      end
    end
    [current_best, best_team.name]
  end

  def worst_all_play_record(season = 2014)
    current_worst = 2
    worst_team = nil

    teams.each do |team|
      percentage = team.all_play_by_season_percentage
      if percentage < current_worst
        current_worst = percentage
        worst_team = team
      end
    end
    [current_worst, worst_team.name]
  end

  def highest_season_total(season=2014)
    current_highest = 0
    highest_team = nil

    teams.each do |team|
      if team.season_total(season) > current_highest
        current_highest = team.season_total(season)
        highest_team = team
      end
    end
    [current_highest, highest_team.name]
  end

  def lowest_season_total(season=2014)
    current_lowest = 10000000000000
    lowest_team = nil

    teams.each do |team|
      if team.season_total(season) < current_lowest
        current_lowest = team.season_total(season)
        lowest_team = team
      end
    end
    [current_lowest, lowest_team.name]
  end

  def best_week(season=2014)
    current_highest = 0
    highest_team = nil
    week = 0

    teams.each do |team|
      if team.best_week(season)[0] > current_highest
        current_highest = team.best_week(season)[0]
        highest_team = team
        week = team.best_week(season)[1]
      end
    end
    [current_highest, highest_team.name, week]
  end

  def worst_week(season = 2014)
    current_lowest = 100000000
    lowest_team = nil
    week = 0

    teams.each do |team|
      if team.worst_week(season)[0] < current_lowest
        current_lowest = team.worst_week(season)[0]
        lowest_team = team
        week = team.worst_week(season)[1]
      end
    end
    [current_lowest, lowest_team.name, week]
  end

  def current_year
    Time.now.year
  end

  def qb_count(year = current_year)
    self.roster_counts.find_by(year: year).qb
  end

  def rb_count(year = current_year)
    self.roster_counts.find_by(year: year).rb
  end

  def wr_count(year = current_year)
    self.roster_counts.find_by(year: year).wr
  end

  def te_count(year = current_year)
    self.roster_counts.find_by(year: year).te
  end

  def k_count(year = current_year)
    self.roster_counts.find_by(year: year).k
  end

  def d_st_count(year = current_year)
    self.roster_counts.find_by(year: year).d_st
  end

  def lb_count(year = current_year)
    self.roster_counts.find_by(year: year).lb
  end

  def db_count(year = current_year)
    self.roster_counts.find_by(year: year).db
  end

  def dl_count(year = current_year)
    self.roster_counts.find_by(year: year).dl
  end

  def flex_count(year = current_year)
    self.roster_counts.find_by(year: year).flex
  end

  def dt_count(year = current_year)
    self.roster_counts.find_by(year: year).dt
  end

  def de_count(year = current_year)
    self.roster_counts.find_by(year: year).de
  end

  def cb_count(year = current_year)
    self.roster_counts.find_by(year: year).cb
  end

  def s_count(year = current_year)
    self.roster_counts.find_by(year: year).s
  end

end
