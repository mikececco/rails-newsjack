class PagesController < ApplicationController
  def home
  end
  def submit_email
    email = MailList.new(email: params[:email])
    if email.save
      # If the email is saved successfully, you can redirect to a success page or show a flash message.
      redirect_to root_path
    else
      # If there are validation errors, you can render the form again with error messages.
      render 'new' # Replace 'new' with the name of your form view.
    end

  end

end
