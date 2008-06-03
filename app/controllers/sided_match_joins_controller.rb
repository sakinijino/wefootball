class SidedMatchJoinsController < ApplicationController
  before_filter :login_required
  
  def create
    @sided_match = SidedMatch.find(params[:sided_match_id])
    @team = @sided_match.host_team
    if (@sided_match.has_joined_member?(current_user))
      redirect_to sided_match_path(@sided_match)
    elsif !@sided_match.can_be_joined_by?(current_user)
      fake_params_redirect     
    else
      @mj = SidedMatchJoin.find_or_initialize_by_user_id_and_match_id(self.current_user.id, @sided_match.id)
      @mj.status = SidedMatchJoin::JOIN
      @mj.save!
      redirect_to sided_match_path(@sided_match)
    end
  end
  
  def destroy
    @sided_match = SidedMatch.find(params[:sided_match_id])
    if !@sided_match.can_be_quited_by?(current_user)
      fake_params_redirect      
      return
    end
    @sided_match_join = SidedMatchJoin.find_by_match_id_and_user_id(@sided_match,current_user)    
    SidedMatchJoin.destroy(@sided_match_join)
    redirect_to sided_match_path(@sided_match_join.match_id)
  end
  
  def edit_formation
    @sided_match = SidedMatch.find(params[:match_id])
    @team = @sided_match.host_team
    if !@sided_match.can_be_edited_formation_by?(current_user)
      fake_params_redirect
      return
    end

    @player_mjs = SidedMatchJoin.players(@sided_match)       
    @position_hash = {}
    Position::POSITIONS.each { |pos| @position_hash[pos] = []}
    @player_mjs.each do |ut|
      user = ut.user
      user.positions_array.each do |pos| 
        @position_hash[pos] << user
      end
    end
    @title = "设置#{@team.shortname}的首发阵型"
    @match = @sided_match
    render :layout => "match_layout"
  end
  
  def update_formation
    @sided_match = SidedMatch.find(params[:match_id])
    @team = @sided_match.host_team
    if !@sided_match.can_be_edited_formation_by?(current_user)
      fake_params_redirect
      return
    end
    
    SidedMatchJoin.transaction do
      SidedMatchJoin.update_all(["position = ?", nil], ["match_id = ? and position is not null", @sided_match.id])
      current_formation_length = 0
      pos_to_ut_hash = params[:formation] ? params[:formation] : {}
      Team::FORMATION_POSITIONS.each do |pos|
        pos = pos.to_s
        if pos_to_ut_hash[pos]
          ut = SidedMatchJoin.find(pos_to_ut_hash[pos])
          raise ApplicationController::FakeParametersError if (ut.match_id != @sided_match.id)
          ut.position = pos
          ut.save!
          current_formation_length+=1 if ut.position!=nil
          raise ApplicationController::FakeParametersError if current_formation_length > @sided_match.size
        end
      end
      flash[:notice] = "阵型已保存"      
      redirect_to edit_formation_sided_match_joins_path(:match_id=>@sided_match.id)
    end
  rescue ApplicationController::FakeParametersError
    fake_params_redirect
  end

end
