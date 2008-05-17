class WatchJoin < ActiveRecord::Base
  belongs_to :user
  belongs_to :watch
  
  def after_destroy
    if WatchJoin.find_all_by_watch_id(self.watch_id).empty?
      Watch.destroy(self.watch_id)
    end
  end
  
  def before_destroy
    Watch.update_all('watch_join_count=watch_join_count-1', ['id = ?', self.watch_id])
    OfficialMatch.update_all('watch_join_count=watch_join_count-1', ['id = ?', self.watch.official_match_id])            
  end

  def after_create
    Watch.update_all('watch_join_count=watch_join_count+1', ['id = ?', self.watch_id])
    OfficialMatch.update_all('watch_join_count=watch_join_count+1', ['id = ?', self.watch.official_match_id])    
  end
end
