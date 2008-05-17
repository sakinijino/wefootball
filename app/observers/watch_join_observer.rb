class WatchJoinObserver < ActiveRecord::Observer
  def after_create(watch_join)  
    WatchJoinBroadcast.create!(:user_id=>watch_join.user_id,
                              :activity_id=>watch_join.watch_id)
  end
end
