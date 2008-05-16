module ActivityHelper  
  def icon
    self.class::ICON
  end
  
  def img_title
    self.class::IMG_TITLE
  end
  
  def time_status_text
    self.class::TIME_STATUS_TEXTS[time_key]
  end
  
  def join_status_text(user, team=nil)
    self.class::JOIN_STATUS_TEXTS[time_key][join_key(user, team)]
  end
  
  def join_links_text(user, team=nil)
    self.class::JOIN_LINKS_TEXTS[time_key][join_key(user, team)]
  end
  
  protected
  def time_key
    if !started?
      :before
    elsif finished?
      :after
    else
      :in
    end
  end
  
  def join_key(user, team=nil)
    if has_joined_member?(user)
      :joined
    elsif has_member?(user)
      :undetermined
    else
      :unjoined
    end
  end
  
  public
end
