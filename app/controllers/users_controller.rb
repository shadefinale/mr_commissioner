class UsersController < ApplicationController

  layout 'login'

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      sign_in(@user)
      flash[:success] = "Welcome to Mr. Commissioner #{@user.username}!"
      redirect_to leagues_path
    else
      str = ""
      @user.errors.full_messages.each do |message|
        str += "<li>#{message}</li>"
      end
      flash.now[:error] = str.html_safe
      #  flash.now[:error] = @user.errors.full_messages.join(', ')
      render :new
    end
  end

  # def show
  #   @user = User.find(params[:id])
  # end

  # def edit
  # end

  # def update
  #   if current_user.update(user_params)
  #     flash[:success] = "Your profile was updated"
  #     redirect_to user_path(current_user)
  #   else
  #     flash.now[:error] = current_user.errors.full_messages
  #     render :edit
  #   end
  # end

  # def destroy
  #   current_user.destroy
  #   sign_out
  #   flash[:success] = "Your account was successfully deleted from Mr. Commissioner. Sad to see you leave!"
  #   redirect_to root_path
  # end

  private

  def user_params
    params.require(:user).permit( :username,
                                  :password,
                                  :password_confirmation)
  end
end
