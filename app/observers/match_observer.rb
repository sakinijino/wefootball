class MatchObserver < ActiveRecord::Observer
  def after_create(match)
    MatchCreationBroadcast.create!(:team_id=>match.host_team_id,
                                   :activity_id=>match.id)
    MatchCreationBroadcast.create!(:team_id=>match.guest_team_id,
                                   :activity_id=>match.id)
  end 
end
