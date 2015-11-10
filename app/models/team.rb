class Team < ActiveRecord::Base
  has_many :player_scores
  belongs_to :league
  has_many :records

  def weekly_scores(week, season=2015)
    # self.player_scores.where(:week_id => get_week_id(week, season)).sum(:points)
    PlayerScore.joins(:week).where("team_id = ? AND weeks.year = ? AND weeks.number = ? AND starter = true", self.id, season, week).sum(:points)
  end

  def best_week(season=2015)
    week = PlayerScore.joins(:week)
    .select("weeks.number, SUM(player_scores.points) as points")
    .where("team_id = ? AND weeks.year = ? AND starter = true", self.id, season)
    .group("player_scores.week_id, weeks.number")
    .order("points DESC")
    .first
    [week.points, week.number]
  end

  def worst_week(season=2015)
    week = PlayerScore.joins(:week)
    .select("weeks.number, SUM(player_scores.points) as points")
    .where("team_id = ? AND weeks.year = ? AND starter = true", self.id, season)
    .group("player_scores.week_id, weeks.number")
    .order("points")
    .first

    [week.points, week.number]
  end

  # def get_all_scores(season=2015)
  #   PlayerScore.joins(:week)
  #   .select("SUM(player_scores.points) as points")
  #   .where("team_id = ? AND weeks.year = ?", self.id, season)
  #   .group("player_scores.week_id")
  # end

  def matchup_count(season = 2015)
    r = Record.find_by(team_id: self.id, year: season)
    r.wins + r.losses + r.ties
  end

  def season_total(season=2015)
    PlayerScore.joins(:week).where("team_id = ? AND weeks.year = ? AND starter = true", self.id, season).sum(:points)
  end



  def all_play_by_week_wins(week, season=2015)
    query = <<-SQL
    WITH weekly_points_table (team_id, max_points)
    AS
    (
      SELECT teams.id, SUM(player_scores.points) as max_points
      FROM player_scores
      INNER JOIN weeks ON weeks.id = player_scores.week_id
      INNER JOIN teams ON teams.id = player_scores.team_id
      WHERE (team_id IN (?) AND weeks.number = ? and weeks.year = ? AND starter = true)
      GROUP BY teams.id
    )
    SELECT COUNT(*) as wins
    FROM weekly_points_table
    WHERE max_points < (SELECT max_points
      FROM weekly_points_table
      WHERE team_id = ?
    )
    SQL

    (PlayerScore.find_by_sql [query, self.league.team_ids, week, season, self.id])[0].wins
  end

  def all_play_by_season_wins(season=2015)
    query = <<-SQL
    WITH weekly_points_table (team_id, week_id, max_points)
    AS
    (
      SELECT teams.id, weeks.id as week_id, SUM(player_scores.points) as max_points
      FROM player_scores
      INNER JOIN weeks ON weeks.id = player_scores.week_id
      INNER JOIN teams ON teams.id = player_scores.team_id
      WHERE (team_id IN (?) AND weeks.year = ? AND starter = true)
      GROUP BY teams.id, weeks.id
    )
    SELECT COUNT(*) as season_wins
    FROM weekly_points_table AS x
    WHERE x.max_points < (SELECT max_points
      FROM weekly_points_table
      WHERE team_id = ? AND x.week_id = weekly_points_table.week_id
    )
    SQL
    (PlayerScore.find_by_sql [query, self.league.team_ids, season, self.id])[0].season_wins
  end

  def all_play_by_week_losses(week, season=2015)
    query = <<-SQL
    WITH weekly_points_table (team_id, max_points)
    AS
    (
      SELECT teams.id, SUM(player_scores.points) as max_points
      FROM player_scores
      INNER JOIN weeks ON weeks.id = player_scores.week_id
      INNER JOIN teams ON teams.id = player_scores.team_id
      WHERE (team_id IN (?) AND weeks.number = ? and weeks.year = ? AND starter = true)
      GROUP BY teams.id
    )
    SELECT COUNT(*) as losses
    FROM weekly_points_table
    WHERE max_points > (SELECT max_points
      FROM weekly_points_table
      WHERE team_id = ?
    )
    SQL

    (PlayerScore.find_by_sql [query, self.league.team_ids, week, season, self.id])[0].losses
  end

  def all_play_seasonal_record(season = 2015)
    query = <<-SQL
      SELECT (SUM(count(week_points < team_points OR NULL)) OVER (ORDER BY 1) :: integer) AS wins,
             (SUM(count(week_points > team_points OR NULL)) OVER (ORDER BY 1) :: integer) AS losses,
             (SUM(count(week_points = team_points OR NULL)) OVER (ORDER BY 1) :: integer) AS draws
      --     , count(*) AS total -- redundant check
      FROM (
         SELECT week_id, team_id, sum(points) AS week_points
              , first_value(sum(points)) OVER (PARTITION BY week_id
                                               ORDER BY team_id <> ?) AS team_points
         FROM  (SELECT id AS week_id FROM weeks WHERE year = ?) w  -- your year
         CROSS  JOIN unnest(ARRAY[?]::int[]) t(team_id)  -- your teams, see below!
         JOIN   player_scores p USING (week_id, team_id)
         WHERE  EXISTS (  -- only weeks where the team actually played
            SELECT 1 FROM player_scores
            WHERE week_id = p.week_id
            AND   team_id = ?
            )
         GROUP  BY 1, 2
         ) sub
      WHERE  team_id <> ?  -- your team_id again
    SQL

    record = (Team.find_by_sql [query, self.id, season,self.league.team_ids, self.id, self.id])[0]

    "#{record.wins}-#{record.losses}-#{record.draws}"
  end

  def all_play_records_by_week(season = 2015)
    query = <<-SQL
    SELECT week_id
      , count(week_points > team_points OR NULL) AS losses
      , count(week_points < team_points OR NULL) AS wins
      , count(week_points = team_points OR NULL) AS draws
    --     , count(*) AS total -- redundant check
    FROM (
       SELECT week_id, team_id, sum(points) AS week_points
            , first_value(sum(points)) OVER (PARTITION BY week_id
                                             ORDER BY team_id <> ?) AS team_points
       FROM  (SELECT id AS week_id FROM weeks WHERE year = ?) w  -- your year
       CROSS  JOIN unnest(ARRAY[?]::int[]) t(team_id)  -- your teams, see below!
       JOIN   player_scores p USING (week_id, team_id)
       WHERE  EXISTS (  -- only weeks where the team actually played
          SELECT 1 FROM player_scores
          WHERE week_id = p.week_id
          AND   team_id = ?
          )
       GROUP  BY 1, 2
       ) sub
    WHERE  team_id <> ?  -- your team_id again
    GROUP  BY 1;
    SQL

    records = Team.find_by_sql [query, self.id, season, self.league.team_ids, self.id, self.id]
  end



  def all_play_by_season_losses(season=2015)
    query = <<-SQL
    WITH weekly_points_table (team_id, week_id, max_points)
    AS
    (
      SELECT teams.id, weeks.id as week_id, SUM(player_scores.points) as max_points
      FROM player_scores
      INNER JOIN weeks ON weeks.id = player_scores.week_id
      INNER JOIN teams ON teams.id = player_scores.team_id
      WHERE (team_id IN (?) AND weeks.year = ?)
      GROUP BY teams.id, weeks.id
    )
    SELECT COUNT(*) as season_losses
    FROM weekly_points_table AS x
    WHERE x.max_points > (SELECT max_points
      FROM weekly_points_table
      WHERE team_id = ? AND x.week_id = weekly_points_table.week_id
    )
    SQL
    (PlayerScore.find_by_sql [query, self.league.team_ids, season, self.id])[0].season_losses
  end

  def all_play_by_week_record(week, season=2015)
    wins = all_play_by_week_wins(week, season)
    losses = all_play_by_week_losses(week, season)
    ties = (self.league.teams.count-1) - (wins + losses)
    "#{wins}-#{losses}-#{ties}"
  end

  def all_play_by_season_record(season=2015)
    wins = all_play_by_season_wins(season)
    losses = all_play_by_season_losses(season)
    ties = ((self.league.teams.count-1) * (self.league.roster_counts.first.matchup_count)) - (wins + losses)
    "#{wins}-#{losses}-#{ties}"
  end

  def all_play_by_week_percentage(week, season=2015)
    (all_play_by_week_wins(week, season).to_f / (self.league.teams.count - 1)).round(3)
  end

  def all_play_by_season_percentage(season=2015)
    (all_play_by_season_wins(season).to_f / ((self.league.teams.count - 1) * self.league.roster_counts.first.matchup_count)).round(3)
  end

  def actual_record(season = 2015)
    record = self.records.find_by(year: season)
    "#{record.wins}-#{record.losses}-#{record.ties}"
  end

  def actual_wins(season = 2015)
    self.records.find_by(year: season).wins
  end

  def average_all_play_wins(season = 2015)
    (self.all_play_by_season_wins.to_f / self.matchup_count(season)).round
  end

  def wins_over_average(season = 2015)
    actual_wins(season) - average_all_play_wins(season)
  end

  # 'Luck' Factor

  def luck_factor(wins_over_average)
    case wins_over_average
    when 3..100
      "Super Lucky"
    when 2
      "Very Lucky"
    when 1
      "Lucky"
    when 0
      "No Luck"
    when -1
      "Unlucky"
    when -2
      "Very Unlucky"
    when -100..-3
      "Super Unlucky"
    else
      "NaN"
    end
  end


end
