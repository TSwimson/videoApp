class UsersController < ApplicationController

  #new user form
  def new
    @user = User.new
  end
  
  #Maybe allow viewing a list of a users videos
  # def show
  #   @user = User.find(params[:id])
  # end

  #create a user 
  #if succesfull redirect to root
  #else send them back to signup page
  def create
    @user = User.new(user_params)

    if @user.save
      sign_in @user
      redirect_to '/'
    else
      render 'new'
    end

  end

  #return the new user parameters
  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

end
