class LeaguesUsersController < ApplicationController
  before_action :require_login
  def destroy
    target = League.find_by_id(params[:id])
    current_user.leagues -= [target] if target
    redirect_to leagues_path
  end
end
