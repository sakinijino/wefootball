class Reply < ActiveRecord::Base
  belongs_to :team
  belongs_to :user
  belongs_to :post, :counter_cache => true
  
  validates_length_of :content, :minimum =>2, :message => "内容太短了, 最少也写2个字吧"
  
  attr_accessible :content
  
  def before_create
    self.team_id = self.post.team_id
  end
  
  def can_be_destroyed_by?(user)
    self.user_id == get_user_id(user) || 
      UserTeam.find_by_user_id_and_team_id_and_is_admin(get_user_id(user), self.team_id, true) != nil
  end

private
  def get_user_id(user)
    case user
    when User
      user.id
    else
      user
    end
  end
end
