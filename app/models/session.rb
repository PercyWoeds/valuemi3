class Session < ActiveRecord::Base
  self.per_page = 20
  attr_accessible :session_id,:data,:user_id,:session
  
  belongs_to :user
end
