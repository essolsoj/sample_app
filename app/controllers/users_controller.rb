class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:edit, :update, :index, :destroy]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy
  before_filter :signed_in_try_to_create,   only: [:new, :create]

  def signed_in_try_to_create
    if signed_in? then redirect_to root_url, notice: "Operation not allowed" end
  end

   def correct_user
      @user = User.find(params[:id]) #the user that the page tries to access
      redirect_to(root_path) unless (current_user==@user) #current user is the signed in user
  end
  def admin_user
      redirect_to(root_path) unless current_user.admin?
  end

  # RESTFUL implementation
  def new
  	@user = User.new #@user is a shared instance variable. It is always overwritten by any instance of this class.
  end
  def show
    @user = User.find(params[:id]) #available in corresponding erb layouts
    @microposts = @user.microposts.paginate(page: params[:page])
  end
  def create
  	@user = User.new(params[:user])
    if @user.save
      # Handle a successful save: go to /users/id where id is taken form the @user name automatically
      sign_in @user
      flash[:success] = "Welcome "+@user.name+" to the Sample App!"
      redirect_to @user
    else
      render 'new' #new.html.erb in the users view
    end
  end
  def edit
    #correct_user already defines @user
    #@user = User.find(params[:id])
  end
  def update
    #@user = User.find(params[:id])
    if @user.update_attributes(params[:user]) #use active record to update the DB for this user
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end
  def index
      @users = User.paginate(page: params[:page])
  end
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end
end
