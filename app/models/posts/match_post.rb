class MatchPost < Post
  belongs_to :match, :class_name => "Match", :foreign_key => :activity_id
  
  ICON = Match::ICON
  IMG_TITLE = Match::IMG_TITLE
  
  def activity
    match
  end
  
  def activity=(act)
    self.match = act
  end
end
