class MatchesController < ApplicationController  
  before_filter :login_required, :only=>[:create,:edit,:update,:destroy]
  
  POSTS_LENGTH = 10

  def show
    @match = Match.find(params[:id])  
    @host_team_player_mjs = MatchJoin.find :all,
      :conditions => ["match_id=? and team_id=? and position is not null",@match.id,@match.host_team_id],
      :order => "position"
    @host_formation_array = @host_team_player_mjs.map {|ut| ut.position}
    
    @guest_team_player_mjs = MatchJoin.find :all,
      :conditions => ["match_id=? and team_id=? and position is not null",@match.id,@match.guest_team_id],
      :order => "position"
    @guest_formation_array = @guest_team_player_mjs.map {|ut| ut.position}
    
    if (logged_in? && current_user.is_team_member_of?(@match.host_team_id))
      @host_posts = @match.posts.team(@match.host_team_id, :limit=>POSTS_LENGTH)
    else
      @host_posts = @match.posts.team_public(@match.host_team_id, :limit=>POSTS_LENGTH)
    end
    if (logged_in? && current_user.is_team_member_of?(@match.guest_team_id))
      @guest_posts = @match.posts.team(@match.guest_team_id, :limit=>POSTS_LENGTH)
    else
      @guest_posts = @match.posts.team_public(@match.guest_team_id, :limit=>POSTS_LENGTH)
    end
    
    @host_team_mj = MatchJoin.find_by_user_id_and_team_id_and_match_id(current_user, @match.host_team, @match)
    @guest_team_mj = MatchJoin.find_by_user_id_and_team_id_and_match_id(current_user, @match.guest_team, @match)

    render :layout=>'match_layout'
  end
  
  def joined_users
    @match = Match.find(params[:id])
    @team = Team.find(params[:team_id])
    @title = "#{@team.name}已决定参加的人"
    @users = @match.users.joined_with_team_id(@team)
    render :action=>'users', :layout=>'match_layout'    
  end
  
  def undetermined_users
    @match = Match.find(params[:id])
    @team = Team.find(params[:team_id])
    @title = "#{@team.name}尚未决定是否参加的人"      
    @users = @match.users.undetermined_with_team_id(@team)
    render :action=>'users', :layout=>'match_layout'    
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
    if !@match.can_be_edited_result_by?(current_user, @team)
      fake_params_redirect      
      return
    end
    @editing_by_host_team = (@team.id == @match.host_team_id)
    @player_mjs = MatchJoin.players(@match.id,@team.id)
    
    @title = "填写赛果"
    render :layout=>'match_layout'
  end

  def update 
    @match = Match.find(params[:id])    
    @team = Team.find(params[:team_id])
    
    if !@match.can_be_edited_result_by?(current_user, @team)
      fake_params_redirect      
      return
    end
    
    @player_mjs = MatchJoin.players(@match.id,@team.id)
    player_mjs_hash = @player_mjs.group_by{|mj| mj.id}
    @match_join_hash = {}
    filled_goal_sum = 0
    if params[:mj]
      params[:mj].map{|k,v| [k,{:goal=>v[:goal],:cards=>v[:cards]}]}.each do |i|
        if !player_mjs_hash.has_key?(i[0].to_i)
          fake_params_redirect      
          return
        end
        @match_join_hash[i[0]] = i[1]
        filled_goal_sum += i[1][:goal].to_i
      end
    end
    
    @editing_by_host_team = (@team.id == @match.host_team_id)
    if @editing_by_host_team
      @match.host_team_goal_by_host = params[:match][:host_team_goal_by_host]       
      @match.guest_team_goal_by_host = params[:match][:guest_team_goal_by_host]     
      @match.situation_by_host = params[:match][:situation_by_host]
    else
      @match.host_team_goal_by_guest = params[:match][:host_team_goal_by_guest]      
      @match.guest_team_goal_by_guest = params[:match][:guest_team_goal_by_guest]
      @match.situation_by_guest = params[:match][:situation_by_guest]  
    end
    
    if ((@editing_by_host_team && !@match.host_team_goal_by_host.blank? && (@match.host_team_goal_by_host<filled_goal_sum)) ||
          (!@editing_by_host_team && !@match.guest_team_goal_by_guest.blank? && (@match.guest_team_goal_by_guest<filled_goal_sum)))
      @match.errors.add_to_base("队员入球总数不能超过本队入球数")
      @title = "填写赛果"
      render :action => "edit", :layout=>'match_layout'
      return
    end
    
    begin
      Match.transaction do
        @match.save!
        raise ActiveRecord::RecordInvalid if !MatchJoin.update(@match_join_hash.keys, @match_join_hash.values)
        redirect_to match_path(@match)
      end
    rescue ActiveRecord::RecordInvalid => e
      @player_mjs = MatchJoin.players(@match.id,@team.id)      
      @title = "填写赛果"
      render :action => "edit", :layout=>'match_layout'
    end
  end

  def destroy
    @match = Match.find(params[:id])    
    if !@match.can_be_destroyed_by?(current_user)#权限检查
      fake_params_redirect
    else
      @match.destroy
      if current_user.is_team_admin_of?(@match.host_team)
        redirect_to team_view_path(@match.host_team_id)
      else
        redirect_to team_view_path(@match.guest_team_id)
      end
    end
  end
end
