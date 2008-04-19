class Post < ActiveRecord::Base
  belongs_to :team
  belongs_to :user
  belongs_to :training
  belongs_to :match
  belongs_to :sided_match

  has_many :replies, :dependent => :destroy
  
  validates_presence_of     :title, :message => "标题不能为空"
  validates_length_of :title, :maximum =>100, :message => "标题最长为100个字"
  validates_length_of :content, :minimum =>5, :message => "内容太短了, 最少也写5个字吧"
  
  attr_accessible :title, :content, :is_private
  
  def is_visible_to?(user)
    !self.is_private || self.user_id == get_user_id(user) || 
      UserTeam.find_by_user_id_and_team_id(get_user_id(user), self.team_id) != nil
  end
  
  def can_be_replied_by?(user)
    user.is_team_member_of?(self.team_id)
  end
  
  def can_be_modified_by?(user)
    self.user_id == get_user_id(user)
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
