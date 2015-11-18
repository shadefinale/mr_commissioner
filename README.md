# Mr. Commissioner

##What it does

Mr. Commissioner is a fantasy football statiscs app. Enter your ESPN League ID number and enter it at [mr-commissioner.herokuapp.com]() and the app will scrape your ESPN fantasy football homepage and provide you with relevant statistics including:

####League Stats
Best Season Total - Team with the highest combined score.

Worst Season Total - Team with the lowest combined score.

Best Individual Score - Team with the highest single week score

Worst Individual Score - Team with the lowest single week score

####Team Stats
All play Record - If you played every team team in a given week. In other words, a count of how many teams you did better than, and how many teams you did worse than. This is given for each individual week, and as a sum of all weeks.

Best Individual Score - The highest Score earned by the team, and the week it occured in.

Worst Individual Score - The lowest Score earned by the team, and the week it occured in.

Luck Factor: By looking at how many games actually won vs how many they were predicted to win based on their all play totals, we can determine their luck factor, i.e. how many games they should have won or lost, but didn't. This is given numerically as 'wins over average' (With a negative number representing losses) and as string as "luck factor"

##How it works

###Landing Page

Users enter a league id on the landing page. When they hit enter, the app checks the database to see if a league with that ID was already attempted to be scraped. If it was scraped successfully, the user is redirected to the league page. If it a scrape was attempted, but failed (because the league ID doesn't exist, or it is set as a private league and unreadable), an error message is returned.

Otherwise, a "Please check back later" message is given, as the scraping duties are handed off to a worker dyno.

####The scraper

When the scraper is initialized, it is passed a leagueID and season to scrape. By default the season is `2015`.  The scraper uses the Mechanize gem.

When the `scrape_all` method is called, Mechanize visits the matchup pages for each team for each week. This means that for a league of 10 teams and 10 weeks, 100 page visits are required.

On each page the scraper collects the players used by each team, their position, and whether or not they were a starter or on the bench. This, along with the week number, league and team id, are all stored in the database.

####The models
The models are by far the most techincally challenging aspect of Mr. Commissioner. Initially, the calculations of best score, worst score, etc. were done using plain Ruby. This required looping through every team in the league and adding up their score. Not too bad. But for the team statistics, we had to for each team, itereate through each player each week and calculate the score before finding the highlest/lowest. That was unreasonalbe. To do the calculations took upwards of a dozen seconds.

So each method had to be rewritten. Because of the way out tables were set up, ActiveRecord was out of the question, so pure SQL was used instead.

Lets walk through an example. We'll see how to build the method to find the highest total score in a league. First we define a season total method on the `Team` class. This is one method that was straight forward enought to use ActiveRecord.

```ruby
# team.rb
def season_total(season = 2015)
  PlayerScore.joins(:week).where("team_id = ? AND weeks.year = ? AND starter = true", self.id, season).sum(:points)
end
```
This method joins the the player_scores table to the weeks table, and finds the sum of points where the season is equal to the season passed in, the team is the instance of the Team class, and the player is a starter.

Next, on `League` class, we define a method to iterate through each team and find the max total score:

```ruby
# league.rb
# old method
def highest_season_total(season = 2015)
  current_hightest = 0
  highest_team = nil

  teams.each do |team|
    if team.season_total(season) > current_highest
    current_highest = team.season_total(season)
    highest_team = team
  end
end
[current_highest, highest_team.name]
```

The new method, using SQL looks like this:

```ruby
def highest_season_total(season = 2015)
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
```

What this query does (in English), is it selects the team name and sum of player\_score points (aliased as total\_points) from the player\_scores table, joined on the teams table joined on the leagues table, joined on the weeks table where the leagueID is the league's own ID, the year is the given season, and the player is a starter. The query then orders the table according to total\_points, and grabs the highest one.

By changing out methods from Ruby to SQL, as we did this one, we were able to get out page load time from 12+ seconds, down to sub 1 second.

##Next steps
The first and biggest step to be taken next is to transform our scraper class from a collection of scripts to a truely object-oriented style class. Doing this will help to isolate bugs that crop in in certain legues regarding the scraping.

After the scraper class is fixed, and bugs are squashed, the next step will be to add more functionality. Some ideas, in no particular order:

* Ideal line-up. Given the starter_count for each league, find the ideal line up for each team each week. Another interesting idea is to find the ideal line-up accross the entire league.
* Player-Score deviation. The best players are the ones most likely not to deviate from their predicted score. Find the players that deviate most and the least in a particular team/league.
* Free agency. Right now the scraper only looks at players actually on a team. Extend the scraper to look at free agents to calulate ideal line-ups/player-score deviation
* Testing using VCR. Right now I have to skip the tests that depend on the
  scraper because they take too long. Set up the test suite to use VCR so these
  tests can be incorporated.




