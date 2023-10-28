class PagesController < ApplicationController
  def home
  end
  def submit_email
    email = MailList.new(email: params[:email])
    if email.save
      # If the email is saved successfully, you can redirect to a success page or show a flash message.
      respond_to do |format|
        format.html { redirect_to root_path }
        format.json { render json: { message: "Email saved successfully" }, status: :ok }
      end
    else
      respond_to do |format|
        format.html { render 'home' }
        format.json { render json: { errors: email.errors.full_messages }, status: :unprocessable_entity }
      end
    end

  end

end
