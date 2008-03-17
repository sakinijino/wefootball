class MatchJoinsController < ApplicationController

  # GET /match_joins/1/edit
  def edit
    @match_id = params[:match_id]
    @team_id = params[:team_id]
    if !Match.find(@match_id).is_bofore_match_close? #只有比赛开始前才可以修改阵形
      fake_params_redirect      
      return
    end    
    if !current_user.is_team_admin_of?(params[:team_id])
      fake_params_redirect
    end
    @player_mjs = MatchJoin.players(params[:match_id],params[:team_id])                               
  end

  def update
    mj = MatchJoin.find(params[:id])
    if !mj.match.is_before_match? #只有比赛开始前才可以修改参加比赛的状态
      fake_params_redirect      
      return
    end    
    if !current_user.is_team_member_of?(params[:team_id])
      fake_params_redirect
      return
    end
    match_join_hash = {:status=>params[:match_join][:status]}
    mj.update_attributes(match_join_hash)
    redirect_to match_path(mj.match_id)    
  end
  
  def update_all
    @match = Match.find(params[:match_id])
    @team_id = params[:team_id]
    if !@match.is_bofore_match_close? #只有比赛关闭前才可以修改阵型
      fake_params_redirect
      return
    end     
    if !current_user.is_team_admin_of?(params[:team_id])
      fake_params_redirect
      return
    end
    
    match_join_hash = {}
    params[:mj].map{|k,v| [k,{:position=>v[:position]}]}.each do |i|
      match_join_hash[i[0]] = i[1]
    end    
    MatchJoin.update(match_join_hash.keys,match_join_hash.values)
    redirect_to match_path(@match.id)    
  end

  
  def destroy
    @match_join = MatchJoin.find(params[:id])
    @match_join.destroy

    redirect_to match_path(@match_join.match_id)
  end
end
