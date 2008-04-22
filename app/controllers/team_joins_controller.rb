class TeamJoinsController < ApplicationController
  before_filter :login_required, :except => [:index, :formation_index]
  before_filter :before_edit, :only=>[:admin_management, :player_management, :formation_management, :update_formation]
  
  def index
    if (params[:user_id]) # 显示用户参加的所有球队
      @user = User.find(params[:user_id], :conditions=>"activated_at is not null")
      @admin_teams = @user.teams.admin
      @other_teams = @user.teams.find(:all, :conditions => ['is_admin = ?', false])
      @title = "#{@user.nickname}的球队"
      render :action=>"index_team", :layout => 'user_layout'
    else # 显示球队的所有成员
      @team = Team.find(params[:team_id])
      @admin = @team.users.admin
      @players = @team.users.players
      @others = @team.users.find(:all, :conditions => ['is_admin = ? and is_player = ?', false, false])
      @title = "#{@team.shortname}的成员"
      render :action=>"index_user", :layout => "team_layout"
    end
  end
  
  def formation_index
    @team = Team.find(params[:team_id])
    @player_uts = UserTeam.find_all_by_team_id_and_is_player(params[:team_id], true, :include=>[:user], :order => "position")
    @starting_uts = @player_uts.reject {|ut| ut.position == nil}
    @formation_array = @starting_uts.map {|ut| ut.position}
    @subs_uts = @player_uts.reject {|ut| ut.position != nil}
    @title = "#{@team.shortname}的阵型"
    render :layout => "team_layout"
  end
  
  def admin_management
    @admin_uts = UserTeam.find_all_by_team_id_and_is_admin(params[:team_id], true, :include=>[:user])
    @other_uts = UserTeam.find_all_by_team_id_and_is_admin(params[:team_id], false, :include=>[:user])
    @title = "#{@team.shortname}的成员管理"
    render :layout => "team_layout"
  end
  
  def player_management
    @player_uts = UserTeam.find_all_by_team_id_and_is_player(params[:team_id], true, :include=>[:user])
    @other_uts = UserTeam.find :all, 
        :conditions => ["team_id = ? and is_player = ? and users.is_playable = ?", params[:team_id], false, true],
        :include=>[:user]
    @title = "#{@team.shortname}的队员名单管理"
    render :layout => "team_layout"
  end
  
  def formation_management
    @player_uts = UserTeam.find_all_by_team_id_and_is_player(params[:team_id], true, :include=>[:user])
    @position_hash = {}
    Position::POSITIONS.each { |pos| @position_hash[pos] = []}
    @player_uts.each do |ut|
      user = ut.user
      user.positions_array.each do |pos| 
        @position_hash[pos] << user
      end
    end
    @title = "#{@team.shortname}的阵型管理"
    render :layout => "team_layout"
  end
  
  def create
    @tjs = TeamJoinRequest.find(params[:id]) # 根据一个加入球队的请求来创建
    if !@tjs.can_accept_by?(self.current_user)
      fake_params_redirect
      return
    end
    
    @user =@tjs.user
    @team = @tjs.team
    if (@user.is_team_member_of?(@team)) #如果已经在球队中不能申请加入
      redirect_with_back_uri_or_default team_view_path(@tjs.team_id)
      return
    end    
    UserTeam.transaction do
      @tjs.destroy
      @tu = UserTeam.new
      @tu.team_id = @tjs.team_id
      @tu.user_id = @tjs.user_id
      @tu.save!
    end
    redirect_with_back_uri_or_default team_view_path(@tjs.team_id)
  end
  
  def update
    @tj = UserTeam.find(params[:id])
    if (!current_user.is_team_admin_of?(@tj.team_id))
      fake_params_redirect
      return
    end    
    @user =@tj.user
    @team = @tj.team
    params[:ut][:is_player] = false if !@user.is_playable
    tmp = UserTeam.new(:is_admin => params[:ut][:is_admin])
    params[:ut][:is_admin] = @tj.is_admin if(
      tmp.is_admin && !@tj.can_promote_as_admin_by?(current_user)||
      !tmp.is_admin && !@tj.can_degree_as_common_user_by?(current_user))
    if @tj.update_attributes(params[:ut])
      if current_user.is_team_admin_of?(@team)
        redirect_with_back_uri_or_default team_view_path(@team)
      else
        redirect_to team_view_path(@team)
      end
    else
      fake_params_redirect
    end
  end
  
  def update_formation
    UserTeam.transaction do
      UserTeam.update_all(["position = ?", nil], ["team_id = ? and position is not null", @team.id])
      current_formation_length = 0
      pos_to_ut_hash = params[:formation] ? params[:formation] : {}
      Team::FORMATION_POSITIONS.each do |pos|
        pos = pos.to_s
        if pos_to_ut_hash[pos]
          ut = UserTeam.find(pos_to_ut_hash[pos])
          raise ApplicationController::FakeParametersError if (ut.team_id != @team.id)
          ut.position = pos
          ut.save!
          current_formation_length+=1 if ut.position!=nil
          raise ApplicationController::FakeParametersError if current_formation_length > UserTeam::FORMATION_MAX_LENGTH
        end
      end
      redirect_to formation_management_team_joins_path(:team_id => @team)
    end
  rescue ApplicationController::FakeParametersError
    fake_params_redirect
  end
  
  def destroy
    @tj = UserTeam.find(params[:id])
    if (!@tj.can_destroy_by?(self.current_user))
      redirect_with_back_uri_or_default team_view_path(@tj.team_id)
    else
      @tj.destroy
      redirect_with_back_uri_or_default team_view_path(@tj.team_id)
    end
  end

protected
  def before_edit
    @team = Team.find(params[:team_id])
    fake_params_redirect if (!current_user.is_team_admin_of?(@team))
  end
end
