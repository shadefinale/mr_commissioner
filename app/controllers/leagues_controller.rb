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
    if params[:id].to_i > 0 && params[:id].to_i < 2147483647
      league = League.find_by("id = ?", params[:id])
      if league
        current_user.leagues << league if current_user && !(current_user.leagues.include?(league))
        redirect_to league
      else
        scrape_new_league(params[:id])
      end
    else
      flash[:notice] = 'The specified league does not exist.'
      redirect_to signin_path
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
        current_user.leagues << league if current_user && !(current_user.leagues.include?(league))
        render :show, League.last
      rescue
        flash[:notice] = 'The specified league does not exist.'
        redirect_to signin_path
      end
    end

end
