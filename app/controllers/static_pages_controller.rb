class StaticPagesController < ApplicationController
  def home
  	if signed_in?
  		#create a new micropost with correct user_id (otherwise not accessible)
  		@micropost = current_user.microposts.build 
  		# get the current microposts for this user (uses function feed)
  		@feed_items = current_user.feed.paginate(page: params[:page])
  	end
  end

  def help
  end

  def about
  end

  def contact
  end
end
