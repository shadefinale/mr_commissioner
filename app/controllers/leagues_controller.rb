class LeaguesController < ApplicationController

  def new
    @league = League.new
  end

  def index
  end

  def create
    #check if leage exists by ID
    #If league doesn't exits
    results = Scraper.new(league_params)
    # league = League.new(id: results.league_id)
  end

  def show
    @league = League.find(143124)
  end


  private

  def league_params
    params.require(:league).permit(:id)
  end

end
