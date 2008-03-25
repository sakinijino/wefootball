class MatchesController < ApplicationController
  
  before_filter :login_required, :only=>[:create,:edit,:update,:destroy]
  
  def index
    if (params[:user_id]) #显示用户参与的比赛
      @user = User.find(params[:user_id], :include=>:matches)
      @matches = @user.matches.recent
      @title = "#{@user.nickname}的比赛"
      render :layout => "user_layout"
    else #显示队伍的所有比赛
      @team = Team.find(params[:team_id])
      @matches = @team.matches.recent
      @title = "#{@team.shortname}的比赛"
      @team_display = false;
      render :layout => "team_layout"
    end    
  end

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
  
  def create
    match_invitation_id = params[:id]
    @match_invitation = MatchInvitation.find(match_invitation_id)
    if !current_user.can_accpet_match_invitation?(@match_invitation)
      fake_params_redirect
      return      
    end
    Match.transaction do
      @match = Match.create_by_invitation(@match_invitation)
      MatchJoin.create_joins(@match)
      MatchInvitation.delete(match_invitation_id)
    end
    redirect_to match_path(@match)
  end

  def edit
    @team = Team.find(params[:team_id])
    @match = Match.find(params[:id],:include=>[:host_team,:guest_team])
    if !@match.is_after_match_and_before_match_close? #只有比赛结束后才可以填写比赛结果和队员比赛信息
      fake_params_redirect      
      return
    end     
    if !current_user.can_edit_match?(@team,@match)
      fake_params_redirect
      return      
    end    
    @editing_by_host_team = (@team.id == @match.host_team_id)
    @player_mjs = MatchJoin.players(@match.id,@team.id) 
  end

  def update 
    @match = Match.find(params[:id])    
    @team = Team.find(params[:team_id])
    if !@match.is_after_match_and_before_match_close? #只有比赛结束后才可以填写比赛结果和队员比赛信息
      fake_params_redirect      
      return
    end    
    if !current_user.can_edit_match?(@team,@match)
      fake_params_redirect
      return      
    end
    @editing_by_host_team = (@team.id == @match.host_team_id)
    if @editing_by_host_team
      @match.guest_team_goal_by_host = params[:match][:guest_team_goal_by_host]
      @match.host_team_goal_by_host = params[:match][:host_team_goal_by_host]      
      if(params[:match][:guest_team_goal_by_host].nil? && params[:match][:host_team_goal_by_host].nil?)
        @match.situation_by_host = params[:match][:situation_by_host]
      else
        @match.situation_by_host = Match.calculate_situation(params[:match][:host_team_goal_by_host],params[:match][:guest_team_goal_by_host] )
      end
    else
      @match.host_team_goal_by_guest = params[:match][:host_team_goal_by_guest]      
      @match.guest_team_goal_by_guest = params[:match][:guest_team_goal_by_guest]
      if(params[:match][:guest_team_goal_by_guest].nil? && params[:match][:host_team_goal_by_guest].nil?)
        @match.situation_by_guest = params[:match][:situation_by_guest]
      else
        @match.situation_by_guest = Match.calculate_situation(params[:match][:host_team_goal_by_guest] ,params[:match][:guest_team_goal_by_guest])
      end     
    end
    
    match_join_hash = {}
    filled_goal_sum = 0
    params[:mj].map{|k,v| [k,{:goal=>v[:goal],:cards=>v[:cards],:comment=>v[:comment]}]}.each do |i|
      match_join_hash[i[0]] = i[1]
      filled_goal_sum += i[1][:goal].to_i
    end
    
    if (
        (@editing_by_host_team && (params[:match][:host_team_goal_by_host].to_i<filled_goal_sum)) ||
        (@editing_by_guest_team && (params[:match][:host_team_goal_by_guest].to_i<filled_goal_sum))
       )
     @player_mjs = MatchJoin.players(@match.id,@team.id)
      render :action => "edit"
      return
    end
    
    if @match.save! && MatchJoin.update(match_join_hash.keys,match_join_hash.values)
      if @editing_by_host_team
        redirect_to team_view_path(@match.host_team_id)
        return
      else
        redirect_to team_view_path(@match.guest_team_id)
        return
      end
    else
      @player_mjs = MatchJoin.players(@match.id,@team.id)      
      render :action => "edit"
      return
    end
  end

  def destroy
    @match = Match.find(params[:id])
    
    if !@match.is_before_match_close? #只有比赛结束后到关闭前才可以填写比赛结果和队员比赛信息
      fake_params_redirect      
      return
    end    
    if !current_user.can_destroy_match?(@match)#权限检查
      fake_params_redirect
      return      
    end
   
    @match.destroy

    if current_user.is_team_admin_of?(@match.host_team)
      redirect_to team_view_path(@match.host_team_id)
      return
    else
      redirect_to team_view_path(@match.guest_team_id)
      return
    end
  end
end