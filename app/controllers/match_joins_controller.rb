class MatchJoinsController < ApplicationController
  before_filter :login_required
  before_filter :before_modify_formation, :only=>[:edit, :update_formation]
  
  def create
    @match = Match.find(params[:match_id])
    @team = Team.find(params[:team_id])
    if (@match.has_joined_team_member?(current_user, @team))
      redirect_to match_path(@match)
    elsif !@match.can_be_joined_by?(current_user, @team)
      fake_params_redirect      
    else
      @mj = MatchJoin.find_or_initialize_by_user_id_and_match_id_and_team_id(self.current_user.id, @match, @team)
      @mj.match = @match
      @mj.team = @team
      @mj.user = self.current_user
      @mj.status = MatchJoin::JOIN
      @mj.save!
      redirect_to match_path(@match)
    end
  end
  
  def destroy
    @match = Match.find(params[:match_id])
    @team = Team.find(params[:team_id])
    if (!@match.can_be_quited_by?(current_user, @team))
      fake_params_redirect
    else
      MatchJoin.destroy_all(["user_id = ? and team_id = ? and match_id = ?", current_user.id, @team.id, @match.id])
      redirect_to match_path(@match)
    end
  end
  
  def edit
    @player_mjs = MatchJoin.players(params[:match_id],params[:team_id])       
    @position_hash = {}
    Position::POSITIONS.each { |pos| @position_hash[pos] = []}
    @player_mjs.each do |ut|
      user = ut.user
      user.positions_array.each do |pos| 
        @position_hash[pos] << user
      end
    end
    @another_team = @team == @match.host_team ? @match.guest_team : @match.host_team
    @title = "设置#{@team.shortname}的首发阵型"
    render :layout => "team_layout"                       
  end
  
  def update_formation  
    MatchJoin.transaction do
      MatchJoin.update_all(["position = ?", nil], ["team_id = ? and match_id = ? and position is not null", @team.id, @match.id])
      current_formation_length = 0
      pos_to_ut_hash = params[:formation] ? params[:formation] : {}
      Team::FORMATION_POSITIONS.each do |pos|
        pos = pos.to_s
        if pos_to_ut_hash[pos]
          ut = MatchJoin.find(pos_to_ut_hash[pos])
          raise ApplicationController::FakeParametersError if (ut.team_id != @team.id || ut.match_id != @match.id)
          ut.position = pos
          ut.save!
          current_formation_length+=1 if ut.position!=nil
          raise ApplicationController::FakeParametersError if current_formation_length > @match.size
        end
      end
      redirect_to match_path(@match)
    end
  rescue ApplicationController::FakeParametersError
    fake_params_redirect
  end

protected
  def before_modify_formation
    @match = Match.find(params[:match_id])
    @team = Team.find(params[:team_id])
    fake_params_redirect if !@match.can_be_edited_formation_by?(current_user, @team)
  end
end
