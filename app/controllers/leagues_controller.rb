class LeaguesController < ApplicationController

  # def new
    #form to submit league_id for scraper
  # end

  def create
    results = Scraper.new(league_params)
    # league = League.new(id: results.league_id)
  end

  def show
  end


  private

  def league_params
    params.require(:league).permit(:id)
  end

end
