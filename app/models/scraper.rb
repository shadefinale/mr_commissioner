# The scraper class is used to glean information from ESPN's fantasy leagues.
class Scraper
  attr_reader :team_count, :league_name, :matchup_count,
              :qb_count,
              :rb_count,
              :wr_count,
              :te_count,
              :dt_count,
              :de_count,
              :lb_count,
              :dl_count,
              :cb_count,
              :s_count,
              :db_count,
              :d_st_count,
              :k_count,
              :flex_count

  def initialize(league_id, season = DateTime.now.year)
    fail ArgumentError unless league_id.to_s =~ /^\d+$/
    @agent = Mechanize.new
    @agent.history_added = Proc.new { sleep 0.1 }
    @league_id = league_id.to_i
    @season = season

    initialize_league_settings unless League.find_by_id(league_id)



  end

  def scrape_all
    t = Time.now
    # week by week scraper
    get_points
    p Time.now - t
  end

  def get_points

    1.upto(matchup_count).each do |w|
      week = get_week(w)
      1.upto(@team_count).each do |e|
        page = @agent.get(scoreboard_page(e, w, 2014))
        team = get_team(e)
        results = page.parser.css('.pncPlayerRow')
        starter_count.times do |player|
          row = results[player]
          player = get_player(row)
          points = points(row)
          PlayerScore.create(week_id: week.id, team_id: team.id,
                          points: points, player_id: player.id,
                          starter: true)
        end
      end
    end
  end

  def points(row)
    points = row.children[-1]
  end


  def get_team(espn_id)
    Team.find_or_create_by(espn_id: espn_id, league_id: @league_id)
  end

  def get_player(row)
    position = row.children[0].text
    name = row.children[1].text.split(',')[0]
    Player.find_or_create_by(name: name, position: position)
  end

  def get_week(w)
    Week.find_or_create_by(number: w, year: @season)
  end


  def initialize_league_settings
    scrape_league_base_page # Does the league exist
    scrape_league_settings_page # Get a count of teams
    # scrape_league_all_teams # For 1 up to count of teams, scrape team.
  end

  def scrape_league_base_page
    page = @agent.get(base_page)
    fail "Invalid leagueID" if page.body.include?('Invalid league specified.')
  end

  def scrape_league_settings_page
    page = @agent.get(settings_page)
    @league_name = page.parser.css('.viewable')[0].text
    create_league
    @team_count = page.parser.css('.viewable')[1].text.to_i

    table = page.parser.css('.viewable .leagueSettingsTable.tableBody').text
    extract_starter_counts(table)

    @matchup_count = page.parser.css('.viewable')[32].text.to_i
    # Populate roster counts table
    # Table is on this page has css path
    # settings-content > div:nth-child(2) > table > tbody > tr.rowOdd > td:nth-child(2) > table
    # Scrape count of each position
    # Create roster_counts object for given league/season with scraped info.
  end

  def extract_starter_counts(table)
    @qb_count   = (table.match(/\(QB\)\d/).to_s[-1]  || "0").to_i
    @rb_count   = (table.match(/\(RB\)\d/).to_s[-1]  || "0").to_i
    @wr_count   = (table.match(/\(WR\)\d/).to_s[-1]  || "0").to_i
    @te_count   = (table.match(/\(TE\)\d/).to_s[-1]  || "0").to_i
    @dt_count   = (table.match(/\(DT\)\d/).to_s[-1]  || "0").to_i
    @de_count   = (table.match(/\(DE\)\d/).to_s[-1]  || "0").to_i
    @lb_count   = (table.match(/\(LB\)\d/).to_s[-1]  || "0").to_i
    @dl_count   = (table.match(/\(DL\)\d/).to_s[-1]  || "0").to_i
    @cb_count   = (table.match(/\(CB\)\d/).to_s[-1]  || "0").to_i
    @s_count    = (table.match(/\(S\)\d/).to_s[-1]   || "0").to_i
    @db_count   = (table.match(/\(DB\)\d/).to_s[-1]  || "0").to_i
    @k_count    = (table.match(/\(K\)\d/).to_s[-1]   || "0").to_i
    @d_st_count = (table.match(/\(D\/ST\)\d/).to_s[-1]   || "0").to_i
    @flex_count = (table.match(/Flex\D*\d/).to_s[-1] || "0").to_i
  end

  def scrape_league_all_teams
    # 1.upto(@team_count) do |team_num|
    #   For each team, go to team page
    #   process team
    # end
    scrape_team(1)
  end

  def starter_count
    @qb_count +
    @rb_count +
    @wr_count +
    @te_count +
    @dt_count +
    @de_count +
    @lb_count +
    @dl_count +
    @cb_count +
    @s_count  +
    @db_count +
    @k_count  +
    @d_st_count +
    @flex_count
  end

  # Scrape team for 1 week
  def scrape_team(team_num)
    # page = @agent.get(team_page(team_num))
    # For all players
    # Create player score in DB for given week/team/league
    # Players are a row on table starting with id="plyr" followed by digits.
    #   Inside this row, there is a td with class "playertablePlayerName"
    #   Position is in same td as name immediately after a ;nbsp
    #   1st instance of class="playertableStatappliedPoints" is points
    #   1st TD in tr contains the position played or "BENCH"

  end

  def team_page(team_num)
    'http://games.espn.go.com/ffl/clubhouse?'\
    "leagueId=#{@league_id}"\
    "teamId=#{team_num}&"\
    "seasonId=#{@season}"
  end

  def scoreboard_page(team_id, week, season)
    "http://games.espn.go.com/ffl/boxscorequick?"\
    "leagueId=#{@league_id}"\
    "&teamId=#{team_id}"\
    "&scoringPeriodId=#{week}"\
    "&seasonId=#{season}"\
    "&view=scoringperiod&version=quick"
  end

  def base_page
    'http://games.espn.go.com/ffl/leagueoffice?'\
    "leagueId=#{@league_id}&seasonId=#{@season}"
  end

  def settings_page
    "http://games.espn.go.com/ffl/leaguesetup/settings?"\
    "leagueId=#{@league_id}&seasonId=#{@season}"
  end

  def create_league
    league = League.new(id: @league_id, name: @league_name)
    league.save
  end
end
