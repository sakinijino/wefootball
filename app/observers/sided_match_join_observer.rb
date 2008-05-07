class SidedMatchJoinObserver < ActiveRecord::Observer
  def after_save(sided_match_join)
    if sided_match_join.status == SidedMatchJoin::JOIN
      SidedMatchJoinBroadcast.create!(:user_id=>sided_match_join.user_id,
                                     :team_id=>sided_match_join.sided_match.host_team_id,
                                     :activity_id=>sided_match_join.match_id)
    end
  end
end
