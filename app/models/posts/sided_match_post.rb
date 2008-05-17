class SidedMatchPost < Post
  belongs_to :sided_match, :class_name => "SidedMatch", :foreign_key => :activity_id
  
  ICON = SidedMatch::ICON
  IMG_TITLE = SidedMatch::IMG_TITLE
  
  def activity
    sided_match
  end
  
  def activity=(act)
    self.sided_match = act
  end
end
