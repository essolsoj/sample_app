module SessionsHelper
  def sign_in(user)
  	#create a permanent cookie with key "remember_token" and value user.remember_token
    cookies.permanent[:remember_token] = user.remember_token
    
# defines a method current_user= expressly designed to handle assignment to current_user. 
#In other words, the code  
#  self.current_user = ... 
#is automatically converted to
#  current_user=(...)
# thereby invoking the current_user= method.

    self.current_user= user
  end

  def current_user=(user)
    @current_user = user # create a shared instance variable (if it does not exist) 
    				     # and assign it the value of user to be signed in
  end
  
#note that the variable @current_user will exist only when the user has done signin in 
#the signin page
#when the user navigates to a different page, the variable @current_user will not exist
#to return the current user, we have to user the remember cookie
  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end
  def current_user?(user)
    current_user == user 
  end

  # this means, return the @current_user if it is not nil, if it is nil then return find_by_remembertoken
  # using the cookies supplied by the browser.
  # find_by_remember_token will be called at least once every time a user visits a different page on the site.

  def signed_in?
     !current_user.nil? #uses above function current_user
  end
  def signed_in_user
    #signedin: user has verified password
    store_location
    redirect_to signin_url, notice: "Please sign in." unless signed_in?
  end
  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url
  end

end
