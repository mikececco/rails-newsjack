class WaitingUsersController < ApplicationController

  def create
    @waiting_user = WaitingUser.new(waiting_user_params)

    if @waiting_user.save
      # Success: Redirect or render something
      flash[:success] = "Yay! 🎉 you successfully joined the waitlist."
      redirect_to root_path
    else
      # Failure: Redisplay the form with errors
      flash[:danger] = "Oops! 🤔 some error."
      redirect_to root_path
    end
  end

  private

  def waiting_user_params
    params.require(:waiting_user).permit(:email)
  end
end
