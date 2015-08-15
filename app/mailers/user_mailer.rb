class UserMailer < ApplicationMailer
  default from: "from@example.com",
          to: "user@example.com",
          subject: "You've got email from Mr. Commissioner!"

  def notify(user, league_id)
    @user = user
    @league = league_id
    mail(to: @user.email, subject: 'Your league results are ready!')
  end

  def welcome(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Mr. Commissioner!')
  end
end
