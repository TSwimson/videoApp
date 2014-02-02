class SessionsController < ApplicationController
	def create
    user=User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Sign the user in and reload root
      sign_in user
      redirect_to '/'
    else
      # Create an error message and re-render the page
      flash[:error]='Invalid email/password combination'
      redirect_to '/'
    end
  end

  def destroy
      sign_out
      redirect_to root_url
  end
end
