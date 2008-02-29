class MatchInvitationsController < ApplicationController
  before_filter :login_required
  
  def new
    @guest_team_id = params[:guest_team_id]
  end  
  
  def create
    @team = Team.find(params[:training][:team_id])
    if (!current_user.is_team_admin_of?(@team))
      fake_params_redirect
      return
    end
    @matchInvitation = MatchInvitation.new(params[:match_invitation])
    @matchInvitation.host_team = @team
    if @training.save
      redirect_to training_view_path(@training)
    else
      render :action=>"new"
    end
  end

  def destroy
    TrainingJoin.destroy_all(["user_id = ? and training_id = ?", current_user.id, params[:training_id]])
    redirect_to training_view_path(params[:training_id])
  end  
  
  
  
  def index
    @match_invitations = MatchInvitation.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @match_invitations }
    end
  end

  # GET /match_invitations/1
  # GET /match_invitations/1.xml
  def show
    @match_invitation = MatchInvitation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @match_invitation }
    end
  end

  # GET /match_invitations/new
  # GET /match_invitations/new.xml
  def new
    @match_invitation = MatchInvitation.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @match_invitation }
    end
  end

  # GET /match_invitations/1/edit
  def edit
    @match_invitation = MatchInvitation.find(params[:id])
  end

  # POST /match_invitations
  # POST /match_invitations.xml
  def create
    @match_invitation = MatchInvitation.new(params[:match_invitation])

    respond_to do |format|
      if @match_invitation.save
        flash[:notice] = 'MatchInvitation was successfully created.'
        format.html { redirect_to(@match_invitation) }
        format.xml  { render :xml => @match_invitation, :status => :created, :location => @match_invitation }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @match_invitation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /match_invitations/1
  # PUT /match_invitations/1.xml
  def update
    @match_invitation = MatchInvitation.find(params[:id])

    respond_to do |format|
      if @match_invitation.update_attributes(params[:match_invitation])
        flash[:notice] = 'MatchInvitation was successfully updated.'
        format.html { redirect_to(@match_invitation) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @match_invitation.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /match_invitations/1
  # DELETE /match_invitations/1.xml
  def destroy
    @match_invitation = MatchInvitation.find(params[:id])
    @match_invitation.destroy

    respond_to do |format|
      format.html { redirect_to(match_invitations_url) }
      format.xml  { head :ok }
    end
  end
end
