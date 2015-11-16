class LeaguesController < ApplicationController
  before_action :require_login, only: :index

  # Do we ever REALLY have a new action? I think our form partial is enough.
  # def new
  #   @league = League.new
  # end

  def index
    @leagues = current_user.leagues
  end

  def create
    if params[:id].to_i > 0 && params[:id].to_i < 2147483647
      league = League.find_or_create_by(id: params[:id])
      if league.done_scraping
        redirect_to league_path(league)
      elsif league.scrapeable
        current_user.leagues << league if current_user && !(current_user.leagues.include?(league))
        #notify_user(current_user.id, league.id) if current_user
        scrape_new_league(params[:id])
        flash[:notice] = "Please check back in a few minutes"
        redirect_to root_path
      else
        flash[:notice] = "LeagueID not found, or it is a private league."
        redirect_to root_path

      end
    else
      flash[:notice] = "LeagueID not found, or it is a private league."
      redirect_to root_path
    end
  end

  def show
    @league = League.find(params[:id])
    @teams = League.find(params[:id]).teams
  end


  private

    def league_params
      params.require(:league).permit(:id)
    end

    def scrape_new_league(id)
      new_league = League.find_or_create_by(id: id)
      if !new_league.scrapeable
        flash[:notice] = "League cannot be found, or is set to private, or\
          sraping is still in progress."
      else
        new_league.delay.scrape
        flash[:notice] = "Please check back in a few minutes"
      end
      # current_user.leagues << new_league if current_user && !(current_user.leagues.include?(new_league))
    end

    def notify_user(user_id, league_id)
      User.notify_about_results(user_id, league_id)
    end

end
