class LeaguesController < ApplicationController
  before_action :require_login, only: :index

  # Do we ever REALLY have a new action? I think our form partial is enough.
  # def new
  #   @league = League.new
  # end

  def index
    @leagues = current_user.leagues.all
  end

  def create
    league = League.find_by("id = ?", params[:id])
    if league
      current_user.leagues << league if current_user
      redirect_to league
    else
      scrape_new_league(params[:id])
    end
  end

  def show
    @league = League.find(params[:id])
  end


  private

    def league_params
      params.require(:league).permit(:id)
    end

    def scrape_new_league(id)
      begin
        Scraper.new(id, 2014).scrape_all
        current_user.leagues << League.last if current_user
        render :show, League.last
      rescue
        flash[:notice] = 'The specified league does not exist.'
        render :new
      end
    end

end
