 include MicropostsHelper
class Micropost < ActiveRecord::Base
  attr_accessible :content
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  #association to user model (and hence to the user table)
  belongs_to :user
  # order of return
  default_scope order: 'microposts.created_at DESC'
  before_save { self.content = wrap(self.content) } #symbol refers to the user instance
  
end
