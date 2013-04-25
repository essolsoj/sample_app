class SessionsController < ApplicationController
  def create
    user = User.find_by_email(params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      # Sign the user in and redirect to wherever the user came from
      sign_in (user)
      redirect_back_or user
    else
  	  # flash.now displays it only on the first render. flash displays it only on the first request.
  	  # a render does not count as a request
      flash.now[:error] = 'Invalid email/password combination' # Not quite right!
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end
