class FootballGroundSweeper < ActionController::Caching::Sweeper
  observe FootballGround
  
  def after_create(fg)
    expire_page(:controller => "js", :action => "football_ground_select")
  end
  
  def after_update(fg)
    expire_page(:controller => "js", :action => "football_ground_select")
  end
  
  def after_destroy(fg)
    expire_page(:controller => "js", :action => "football_ground_select")
  end
end
