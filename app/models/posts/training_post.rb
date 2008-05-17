class TrainingPost < Post
  belongs_to :training, :class_name => "Training", :foreign_key => :activity_id
  
  ICON = Training::ICON
  IMG_TITLE = Training::IMG_TITLE
  
  def activity
    training
  end
  
  def activity=(act)
    self.training = act
  end
end
