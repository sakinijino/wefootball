class MatchViewsController < ApplicationController

  def show
    @match = Match.find(params[:id])  
    @host_team_player_mjs = MatchJoin.find(:all,
                                         :conditions => ["match_id=? and team_id=? and position is not null",@match.id,@match.host_team_id]
                                        )    
    @host_team_user_mjs = MatchJoin.find_all_by_match_id_and_team_id(@match.id,@match.host_team_id)
    @guest_team_player_mjs = MatchJoin.find(:all,
                                         :conditions => ["match_id=? and team_id=? and position is not null",@match.id,@match.guest_team_id]
                                        )    
    @guest_team_user_mjs = MatchJoin.find_all_by_match_id_and_team_id(@match.id,@match.guest_team_id)
  end
end
