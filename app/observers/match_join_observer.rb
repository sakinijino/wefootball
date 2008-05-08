class MatchJoinObserver < ActiveRecord::Observer
  def before_save(match_join)
    if match_join.status == MatchJoin::JOIN && 
        (match_join.new_record? || match_join.column_changed?(:status))
      MatchJoinBroadcast.create!(:user_id=>match_join.user_id,
                                 :team_id=>match_join.team_id,
                                 :activity_id=>match_join.match_id)
    end
  end
end
