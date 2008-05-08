class SidedMatchJoinObserver < ActiveRecord::Observer
  def before_save(sided_match_join)
    if sided_match_join.status == SidedMatchJoin::JOIN && 
        (sided_match_join.new_record? || sided_match_join.column_changed?(:status))
      SidedMatchJoinBroadcast.create!(:user_id=>sided_match_join.user_id,
                                     :team_id=>sided_match_join.sided_match.host_team_id,
                                     :activity_id=>sided_match_join.match_id)
    end
  end
end
