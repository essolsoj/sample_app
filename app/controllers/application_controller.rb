class ApplicationController < ActionController::Base
  protect_from_forgery
  # all the helpers are available in the views but not in the controllers
  include SessionsHelper

  # Force signout to prevent CSRF attacks
  def handle_unverified_request
    sign_out
    super
  end
end
