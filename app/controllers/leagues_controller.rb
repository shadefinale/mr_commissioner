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
      league = League.find_by("id = ?", params[:id])
      if league
        current_user.leagues << league if current_user && !(current_user.leagues.include?(league))
        notify_user(current_user.id, league.id) if current_user
        redirect_to league
      else
        scrape_new_league(params[:id])
      end
    else
      flash[:notice] = 'The specified league does not exist.'
      redirect_to root_path
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
        new_league = League.order(:created_at).last
        current_user.leagues << new_league if current_user && !(current_user.leagues.include?(new_league))
        redirect_to new_league
      rescue Exception => e
        flash[:notice] = 'The specified league could not be found.'
        redirect_to signin_path
      end
    end

    def notify_user(user_id, league_id)
      User.notify_about_results(user_id, league_id)
    end

end
