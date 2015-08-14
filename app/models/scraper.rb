# The scraper class is used to glean information from ESPN's fantasy leagues.
class Scraper
  # Check if league exists
  # Get initial info
  # Public for now
  # For each team
  #  Go through weeks, scrape info
  #    new player score instance
  #
  #
  def initialize(league_id, season = DateTime.now.year)
    fail ArgumentError unless league_id.to_s =~ /^\d+$/
    @league_id = league_id.to_i
    @season = season
    initialize_league_settings
  end

  def initialize_league_settings
    scrape_league_base_page
  end

  def scrape_league_base_page
  end

  def base_page
    'http://games.espn.go.com/ffl/leagueoffice?'\
    "leagueId=#{@league_id}&seasonId=#{@season}"
  end

  def settings_page
    "http://games.espn.go.com/ffl/leaguesetup/settings?leagueId=#{@league_id}"
  end
end
