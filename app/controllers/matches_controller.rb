class MatchesController < ApplicationController
  # GET /matches
  # GET /matches.xml
  def index
    @matches = Match.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @matches }
    end
  end

  # GET /matches/1
  # GET /matches/1.xml
  def show
    @match = Match.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @match }
    end
  end

  # GET /matches/new
  # GET /matches/new.xml
  def new
    @match = Match.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @match }
    end
  end
  
  # POST /matches
  # POST /matches.xml
  def create
    match_invitation_id = params[:id]
    @match_invitation = MatchInvitation.find(match_invitation_id)
    if !current_user.can_accpet_match_invitation?(@match_invitation)
      fake_params_redirect
      return      
    end
    if @match_invitation.has_been_modified?(params[:match_invitation])#如果用户已经做过修改，则不能创建
      render :action => "edit", :id=>match_invitation_id
      return
    end
    Match.transaction do
      @match = Match.new_by_invitation(@match_invitation)
      @match.save!
      MatchInvitation.delete(match_invitation_id)
    end
    redirect_to match_path(@match)
  end

  # GET /matches/1/edit
  def edit
    @team_id = params[:team_id]
    @match = Match.find(params[:id],:include=>[:host_team,:guest_team])
    if !current_user.can_edit_match?(@team_id,@match)
      fake_params_redirect
      return      
    end    
    @editing_by_host_team = (@team_id.to_s == @match.host_team_id.to_s) 
  end

  # PUT /matches/1
  # PUT /matches/1.xml
  def update
    @team_id = params[:match][:team_id]
    @match = Match.find(params[:id])
    if !current_user.can_edit_match?(@team_id,@match)
      fake_params_redirect
      return      
    end
    @editing_by_host_team = (@team_id.to_s == @match.host_team_id.to_s)
    if @editing_by_host_team
      @match.guest_team_goal_by_host = params[:match][:guest_team_goal_by_host]
      @match.host_team_goal_by_host = params[:match][:host_team_goal_by_host]      
      if(params[:match][:guest_team_goal_by_host].nil? && params[:match][:host_team_goal_by_host].nil?)
        @match.situation_by_host = params[:match][:situation_by_host]
      else
        @match.situation_by_host = @match.calculate_situation(params[:match][:host_team_goal_by_host],params[:match][:guest_team_goal_by_host] )
      end
    else
      @match.host_team_goal_by_guest = params[:match][:host_team_goal_by_guest]      
      @match.guest_team_goal_by_guest = params[:match][:guest_team_goal_by_guest]
      if(params[:match][:guest_team_goal_by_guest].nil? && params[:match][:host_team_goal_by_guest].nil?)
        @match.situation_by_guest = params[:match][:situation_by_guest]
      else
        @match.situation_by_guest = @match.calculate_situation(params[:match][:host_team_goal_by_guest] ,params[:match][:guest_team_goal_by_guest])
      end     
    end
    if @match.save
      if @editing_by_host_team
        redirect_to team_view_path(@match.host_team_id)
      else
        redirect_to team_view_path(@match.guest_team_id)
      end
    else
      render :action => "edit"
    end
  end

  # DELETE /matches/1
  # DELETE /matches/1.xml
  def destroy
    @match = Match.find(params[:id])
    @match.destroy

    respond_to do |format|
      format.html { redirect_to(matches_url) }
      format.xml  { head :ok }
    end
  end
end
