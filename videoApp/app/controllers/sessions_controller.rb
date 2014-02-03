class SessionsController < ApplicationController

  #Create a session for the user to log them in
  #if it works reload index
  #if it doesn't reload index and show error
  def create

    user=User.find_by_email(params[:session][:email].downcase)

    if user && user.authenticate(params[:session][:password])        # Sign the user in and reload root
      sign_in user
      redirect_to '/'
    else
      flash[:error]='Invalid email/password combination'                 # Create an error message and re-render the page
      redirect_to '/'
    end

  end
  #end the current user's session
  def destroy
      sign_out
      redirect_to root_url
  end

end
