class SessionsController < ApplicationController
  before_action :redirect_to_dashboard, only: [:new]

  layout 'login'

  def new
  end

  def create
    @user = User.find_by_username(params[:username])
    if @user && @user.authenticate(params[:password])
      permanent_sign_in(@user)
      flash[:success] = "You've successfully signed in"
      redirect_to leagues_path
    else
      flash.now[:error] = "Wrong username/password combination, please try again!"
      @user = User.new
      render :new
    end
  end

  def destroy
    sign_out
    flash[:success] = "You've successfully signed out"
    redirect_to root_path
  end

end
