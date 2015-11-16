class League < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :teams
  has_many :roster_counts

  def scrape
    Scraper.new(self.id, 2015).scrape_all
  end
  def team_count
    self.teams.count
  end

  def best_all_play_record(season = 2015)
    query = <<-SQL
    WITH weekly_points_table (team_id, record_name, week, team_name, max_points, rank)
    AS
    (
      SELECT teams.id,
             teams.name as record_name,
             weeks.id as week,
             teams.name as team_name,
             SUM(player_scores.points) as max_points,
             rank() OVER (PARTITION BY weeks.id ORDER BY SUM(player_scores.points))
      FROM player_scores
      INNER JOIN weeks ON weeks.id = player_scores.week_id
      INNER JOIN teams ON teams.id = player_scores.team_id
      WHERE (team_id IN (?) AND weeks.year = ? AND starter = true)
      GROUP BY teams.id, weeks.id
    )
    SELECT team_id, record_name, SUM(rank) as record
    FROM weekly_points_table
    GROUP BY team_id, record_name
    ORDER BY record DESC
    LIMIT 1
    SQL
    (PlayerScore.find_by_sql [query, self.team_ids, season])[0].record_name
  end

  def worst_all_play_record(season = 2015)
    query = <<-SQL
    WITH weekly_points_table (team_id, record_name, week, team_name, max_points, rank)
    AS
    (
      SELECT teams.id,
             teams.name as record_name,
             weeks.id as week,
             teams.name as team_name,
             SUM(player_scores.points) as max_points,
             rank() OVER (PARTITION BY weeks.id ORDER BY SUM(player_scores.points))
      FROM player_scores
      INNER JOIN weeks ON weeks.id = player_scores.week_id
      INNER JOIN teams ON teams.id = player_scores.team_id
      WHERE (team_id IN (?) AND weeks.year = ? AND starter = true)
      GROUP BY teams.id, weeks.id
    )
    SELECT team_id, record_name, SUM(rank) as record
    FROM weekly_points_table
    GROUP BY team_id, record_name
    ORDER BY record
    LIMIT 1
    SQL
    (PlayerScore.find_by_sql [query, self.team_ids, season])[0].record_name
  end

  def highest_season_total(season=2015)
    # current_highest = 0
    # highest_team = nil

    # teams.each do |team|
    #   if team.season_total(season) > current_highest
    #     current_highest = team.season_total(season)
    #     highest_team = team
    #   end
    # end
    # [current_highest, highest_team.name]
    query = <<-SQL
    SELECT teams.name, SUM(player_scores.points) as total_points
    FROM player_scores
    INNER JOIN teams ON teams.id = player_scores.team_id
    INNER JOIN leagues ON leagues.id = teams.league_id
    INNER JOIN weeks ON weeks.id = player_scores.week_id
    WHERE (league_id = ? AND weeks.year = 2015 AND starter = true)
    GROUP BY teams.name
    ORDER BY total_points DESC
    LIMIT 1
    SQL
    sql = (PlayerScore.find_by_sql [query, self.id]).first
    [sql.total_points, sql.name]
  end

  def lowest_season_total(season=2015)
    query = <<-SQL
    SELECT teams.name, SUM(player_scores.points) as total_points
    FROM player_scores
    INNER JOIN teams ON teams.id = player_scores.team_id
    INNER JOIN leagues ON leagues.id = teams.league_id
    INNER JOIN weeks ON weeks.id = player_scores.week_id
    WHERE (league_id = ? AND weeks.year = 2015 AND starter = true)
    GROUP BY teams.name
    ORDER BY total_points ASC
    LIMIT 1
    SQL
    sql = (PlayerScore.find_by_sql [query, self.id]).first
    [sql.total_points, sql.name]
  end

  def best_week(season=2015)
    # current_highest = 0
    # highest_team = nil
    # week = 0

    # teams.each do |team|
    #   if team.best_week(season)[0] > current_highest
    #     current_highest = team.best_week(season)[0]
    #     highest_team = team
    #     week = team.best_week(season)[1]
    #   end
    # end

    result = PlayerScore.joins(:week).joins(:team)
    .select("teams.name, weeks.number, SUM(player_scores.points) as points")
    .where("league_id = ? AND weeks.year = ? AND starter = true", self.id, season)
    .group("teams.name, player_scores.week_id, weeks.number")
    .order("points DESC")
    .first
    [result.points, result.name, result.number]
    # [current_highest, highest_team.name, week]
  end

  def worst_week(season = 2015)
    # current_lowest = 100000000
    # lowest_team = nil
    # week = 0

    # teams.each do |team|
    #   if team.worst_week(season)[0] < current_lowest
    #     current_lowest = team.worst_week(season)[0]
    #     lowest_team = team
    #     week = team.worst_week(season)[1]
    #   end
    # end
    result = PlayerScore.joins(:week).joins(:team)
    .select("teams.name, weeks.number, SUM(player_scores.points) as points")
    .where("league_id = ? AND weeks.year = ? AND starter = true", self.id, season)
    .group("teams.name, player_scores.week_id, weeks.number")
    .order("points")
    .first
    [result.points, result.name, result.number]
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
