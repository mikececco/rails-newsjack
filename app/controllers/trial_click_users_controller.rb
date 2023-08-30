class TrialClickUsersController < ApplicationController
  def create
    @trial_user = TrialClickUser.new(trial_user_params)

    if @trial_user.save
      # Success: Redirect or render something
      flash[:success] = "Yay! 🎉 you successfully joined the waitlist. "
      redirect_to root_path
    else
      # Failure: Redisplay the form with errors
      flash[:danger] = "Oops! 🤔 some error. "
      redirect_to root_path
    end
  end

  private

  def trial_user_params
    params.require(:trial_click_user).permit(:company_description)
  end
end
