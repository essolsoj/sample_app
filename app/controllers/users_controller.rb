class UsersController < ApplicationController
  def new
  	@user = User.new #@user is a shared instance variable. It is always overwritten by any instance of this class.
  end
  def show
    @user = User.find(params[:id]) #available in corresponding erb layouts
  end
  def create
  	@user = User.new(params[:user])
    if @user.save
      # Handle a successful save: go to /users/id where id is taken form the @user name automatically
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

end
