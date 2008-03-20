class FootballGroundSweeper < ActionController::Caching::Sweeper
  observe FootballGround
  
  def after_create
    expire_page(:controller => "js", :action => "football_ground_select")
  end
  
  def after_update
    expire_page(:controller => "js", :action => "football_ground_select")
  end
  
  def after_destroy
    expire_page(:controller => "js", :action => "football_ground_select")
  end
end
