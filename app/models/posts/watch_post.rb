class WatchPost < Post
  belongs_to :watch, :class_name => "Watch", :foreign_key => :activity_id
  
  ICON = Watch::ICON
  IMG_TITLE = Watch::IMG_TITLE
  
  def activity
    watch
  end
  
  def activity=(act)
    self.watch = act
  end
  
  def is_visible_to?(user)
    !self.is_private || self.user_id == get_user_id(user) || 
      WatchJoin.find_by_user_id_and_team_id(get_user_id(user), self.activity_id) != nil
  end
  
  def can_be_replied_by?(user)
    self.watch.has_member?(user)
  end
  
  def admin?(user)
    self.watch.can_be_edited_by?(user)
  end
  
  def private_text
    '仅参加活动的成员可见'
  end
  
  def related(user, options={})
    if (user!=nil && watch.has_member?(user))
      watch.posts.find(:all, options) - [self]
    else
      watch.posts.public(options) - [self]
    end
  end
end
