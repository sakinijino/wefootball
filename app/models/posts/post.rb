class Post < ActiveRecord::Base
  belongs_to :team
  belongs_to :user

  has_many :replies, :dependent => :destroy
  
  validates_presence_of     :title, :message => "标题不能为空"
  validates_length_of :title, :maximum =>100, :message => "标题最长为100个字"
  validates_length_of :content, :minimum =>2, :message => "内容太短了, 最少也写2个字吧"
  
  attr_accessible :title, :content, :is_private
  
  def self.get_user_related_posts(user, options={})
    return [] if user.user_teams.size <= 0
    q = {:conditions => [
        "team_id in (?) or (type='WatchPost' and activity_id in (?))", 
        user.user_teams.map{|item| item.team_id},
        user.watch_joins.map{|item| item.watch_id}
      ], 
      :order => "updated_at desc"}.merge(options)
    options.has_key?(:page) ? Post.paginate(:all, q) : Post.find(:all, q)
  end
  
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
    self.user_id == get_user_id(user) || admin?(user) 
  end
  
  
  def admin?(user)
    UserTeam.find_by_user_id_and_team_id_and_is_admin(get_user_id(user), self.team_id, true) != nil
  end
  
  def related(user, options={})
    if (user!=nil && user.is_team_member_of?(team))
      team.posts.find(:all, options) - [self]
    else
      team.posts.public(options) - [self]
    end
  end
  
  def activity
    nil
  end
  
  def activity=(act)
  end
  
  ICON = nil
  IMG_TITLE = nil
  
  def icon
    activity_id.nil? ? nil : self.class::ICON
  end
  
  def img_title
    activity_id.nil? ? nil : self.class::IMG_TITLE
  end
  
  def private_text
    '仅队内可见'
  end

protected
  def get_user_id(user)
    case user
    when User
      user.id
    else
      user
    end
  end
end
