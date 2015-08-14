# The scraper class is used to glean information from ESPN's fantasy leagues.
class Scraper
  attr_reader :team_count

  def initialize(league_id, season = DateTime.now.year)
    fail ArgumentError unless league_id.to_s =~ /^\d+$/
    @agent = Mechanize.new
    @agent.history_added = Proc.new { sleep 0.5 }
    @league_id = league_id.to_i
    @season = season
    initialize_league_settings
  end

  def initialize_league_settings
    scrape_league_base_page # Does the league exist
    scrape_league_settings_page # Get a count of teams
    scrape_league_all_teams # For 1 up to count of teams, scrape team.
  end

  def scrape_league_base_page
    page = @agent.get(base_page)
    fail "Invalid leagueID" if page.body.include?('Invalid league specified.')
  end

  def scrape_league_settings_page
    page = @agent.get(settings_page)
    @team_count = page.parser.css('.viewable')[1].text.to_i
    # Populate roster counts table
    # Table is on this page has css path
    # settings-content > div:nth-child(2) > table > tbody > tr.rowOdd > td:nth-child(2) > table
    # Scrape count of each position
    # Create roster_counts object for given league/season with scraped info.
  end

  def scrape_league_all_teams
    # 1.upto(@team_count) do |team_num|
    #   For each team, go to team page
    #   process team
    # end
    scrape_team(1)
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

  def base_page
    'http://games.espn.go.com/ffl/leagueoffice?'\
    "leagueId=#{@league_id}&seasonId=#{@season}"
  end

  def settings_page
    "http://games.espn.go.com/ffl/leaguesetup/settings?leagueId=#{@league_id}"
  end
end
