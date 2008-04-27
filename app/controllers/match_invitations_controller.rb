class MatchInvitationsController < ApplicationController
  before_filter :login_required, :except => [:index]
  
  def index
    @team = Team.find(params[:team_id])
    if (params[:as] == 'send')
      @mis = MatchInvitation.find :all,
        :conditions=>["(host_team_id = ? and edit_by_host_team = ?) or (guest_team_id = ? and edit_by_host_team = ?)", @team, false, @team, true],
        :order => 'updated_at desc'
      @title = "等待对方回复的约战"
      render :action=>'index_waiting_for_reply', :layout=>"team_layout"
    else
      @mis = MatchInvitation.find :all,
        :conditions=>["(host_team_id = ? and edit_by_host_team = ?) or (guest_team_id = ? and edit_by_host_team = ?)", @team, true, @team, false],
        :order => 'updated_at desc'
      @title = "需要处理的约战"
      render :action=>'index_need_reply', :layout=>"team_layout"
    end
  end
  
  def new    
    @guest_team = Team.find(params[:guest_team_id])   
    if params[:host_team_id].nil?
      @host_teams = current_user.teams.admin - [@guest_team]
      @team = @guest_team
      @title = "从你管理的球队中选择提出约战的球队"
      render :action=>"select_host_team", :layout=>"team_layout"
    else
      if !current_user.is_team_admin_of?(params[:host_team_id])
        fake_params_redirect
        return
      end
      @host_team = Team.find(params[:host_team_id])
      @team = @host_team
      @title = "约战: #{@host_team.shortname} V.S. #{@guest_team.shortname}"
      @match_invitation = MatchInvitation.new
      @match_invitation.new_start_time = 1.day.since
      @match_invitation.new_half_match_length = 45
      @match_invitation.new_rest_length = 15
      @match_invitation.new_has_judge = false
      @match_invitation.new_has_card = false
      @match_invitation.new_has_offside = false
      render :layout=>"team_layout"
    end
  end
  
  def create
    @guest_team_id = params[:match_invitation][:guest_team_id]
    @host_team_id = params[:match_invitation][:host_team_id]
    @guest_team = Team.find(@guest_team_id)
    @host_team = Team.find(@host_team_id)
    if !((@host_team_id != @guest_team_id) && (current_user.is_team_admin_of?(@host_team_id)))
      fake_params_redirect
      return      
    end
    @match_invitation = MatchInvitation.new(params[:match_invitation])
    @match_invitation.guest_team_id = @guest_team_id
    @match_invitation.host_team_id = @host_team_id
    @match_invitation.host_team_message = params[:match_invitation][:host_team_message]
    @match_invitation.edit_by_host_team = false
    if @match_invitation.save
      redirect_to team_match_invitations_path(@host_team, :as => 'send')
    else
      @team = @host_team
      @title = "约战: #{@host_team.shortname} V.S. #{@guest_team.shortname}"
      render :action=>"new", :layout=>"team_layout"
    end
  end
  
  def edit
    @match_invitation = MatchInvitation.find(params[:id],:include=>[:host_team,:guest_team])
    if !current_user.can_edit_match_invitation?(@match_invitation)
      fake_params_redirect
      return
    end
    @unmodified_match_invitation = @match_invitation
    set_teams
    @title = "继续商议: #{@host_team.shortname} V.S. #{@guest_team.shortname}"
    render :layout=>"team_layout"
  end
  
  def update    
    @match_invitation = MatchInvitation.find(params[:id])
    if !current_user.can_edit_match_invitation?(@match_invitation)
      fake_params_redirect
      return
    end   
    @match_invitation.save_last_info!
    @self_team = @match_invitation.edit_by_host_team ? @match_invitation.host_team : @match_invitation.guest_team
    if @match_invitation.edit_by_host_team
      @match_invitation.host_team_message = params[:match_invitation][:host_team_message]        
    else
      @match_invitation.guest_team_message = params[:match_invitation][:guest_team_message]
    end
    @match_invitation.edit_by_host_team = !@match_invitation.edit_by_host_team
    if @match_invitation.update_attributes(params[:match_invitation])     
      redirect_to team_match_invitations_path(@self_team, :as => 'send')
    else
      @unmodified_match_invitation = MatchInvitation.find(params[:id])
      set_teams
      @title = "继续商议: #{@host_team.shortname} V.S. #{@guest_team.shortname}"  
      render :action => "edit", :layout=>"team_layout"
    end
  end
  
  def destroy
    @match_invitation = MatchInvitation.find(params[:id])
    if !current_user.can_reject_match_invitation?(@match_invitation)
      fake_params_redirect
      return
    end
    MatchInvitation.destroy(@match_invitation)
    if @match_invitation.edit_by_host_team == true
      redirect_to team_match_invitations_path(@match_invitation.host_team)
    else
      redirect_to team_match_invitations_path(@match_invitation.guest_team)
    end
  end

  protected
  def set_teams
    @host_team = @unmodified_match_invitation.host_team
    @guest_team = @unmodified_match_invitation.guest_team
    @self_team = @unmodified_match_invitation.edit_by_host_team ? @host_team : @guest_team
    @team = @self_team
    @another_team = @unmodified_match_invitation.edit_by_host_team ? @guest_team : @host_team
  end
end
