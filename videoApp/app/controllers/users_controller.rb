class UsersController < ApplicationController
	def index

	end

  def new
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
  		#sign_in @user
  		redirect_to show_user_path(@user.id)

  	else
  		render 'new'
  	end
  end
  def user_params
  	params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

end
