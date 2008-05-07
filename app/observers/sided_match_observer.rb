class SidedMatchObserver < ActiveRecord::Observer
  def after_create(match)
    SidedMatchCreationBroadcast.create!(:team_id=>match.host_team_id,
                                   :activity_id=>match.id)
  end 
end
