class PagesController < ApplicationController
  def home
  end

  def submit_email
    # Assuming you have the 'email' parameter in the params hash
    @mail_list = MailList.find_or_create_by(email: params[:email])

    @post = GeneratePost.find_or_create_by(id: params[:post_id].to_i)

    # Associate the GeneratePost with the MailList
    @post.mail_list = @mail_list

    puts @post.inspect

    # Save the changes
    @post.save
      # If the email is saved successfully, you can redirect to a success page or show a flash message.
    respond_to do |format|
      if @mail_list.save
        format.turbo_stream do
          render turbo_stream: turbo_stream.update(:results, partial: "pages/submitted", status: :accepted)
        end
      else
        respond_to do |format|
          format.html { render 'home' }
          format.json { render json: { errors: email.errors.full_messages }, status: :unprocessable_entity }
        end
      end
    end
  end

end
