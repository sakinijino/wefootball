class PlayJoinObserver < ActiveRecord::Observer
  def after_create(play_join)  
    PlayJoinBroadcast.create!(:user_id=>play_join.user_id,
                              :activity_id=>play_join.play_id)
  end
end
