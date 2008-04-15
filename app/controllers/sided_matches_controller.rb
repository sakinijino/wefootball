class SidedMatchesController < ApplicationController
  
  before_filter :login_required, :only=>[:create,:edit,:update,:destroy]

  def new
    @team = Team.find(params[:team_id])
    if (!current_user.is_team_admin_of?(@team))
      fake_params_redirect
      return
    end
    @sided_match = SidedMatch.new
    @sided_match.start_time = 1.day.since
    @sided_match.half_match_length = 45
    @sided_match.rest_length = 15
    @sided_match.has_judge = false;
    @sided_match.has_card = false;
    @sided_match.has_offside = false;
    @title = "创建新比赛"
    render :layout => "team_layout"
  end

  def show
    @match = SidedMatch.find(params[:id])  
    @host_team_player_mjs = SidedMatchJoin.find(:all,
        :conditions => ["match_id=? and position is not null",@match.id])    
    @host_formation_array = @host_team_player_mjs.map {|ut| ut.position}
    
    @team = @match.host_team
    render :layout=>'team_layout'    
  end

  def create
    @team = Team.find(params[:sided_match][:host_team_id])
    if (!current_user.is_team_admin_of?(@team))
      fake_params_redirect
      return
    end
    
    @sided_match = SidedMatch.new(params[:sided_match])
    @sided_match.host_team_id = @team.id
    begin
      SidedMatch.transaction do
        @sided_match.save!
        SidedMatchJoin.create_joins(@sided_match)
        redirect_to sided_match_path(@sided_match)   
      end
    rescue ActiveRecord::RecordInvalid => e
      @title = "创建新比赛"
      render :action=>"new", :layout => "team_layout"
    end
  end    

  def edit
    @sided_match = SidedMatch.find(params[:id])   
    if !@sided_match.can_be_edited_by?(current_user)
      fake_params_redirect
      return      
    end
    @title = "编辑比赛"
    @team = @sided_match.host_team
    render :layout=>'team_layout'
  end

  def update  
    @sided_match = SidedMatch.find(params[:id])    
    if !@sided_match.can_be_edited_by?(current_user)
      fake_params_redirect    
    elsif @sided_match.update_attributes(params[:sided_match])
      redirect_to sided_match_path(@sided_match)
    else
      @team = @sided_match.host_team
      @title = "编辑比赛"
      render :action => "edit", :layout=>'team_layout'
      return
    end
  end
  
  def edit_result
    @sided_match = SidedMatch.find(params[:id])   
    if !@sided_match.can_be_edited_result_by?(current_user)
      fake_params_redirect
      return      
    end
    @player_mjs = SidedMatchJoin.players(@sided_match)
    @team = @sided_match.host_team
    render :layout=>'team_layout'     
  end

  def update_result 
    @sided_match = SidedMatch.find(params[:id])
    @team = @sided_match.host_team
    if !@sided_match.can_be_edited_result_by?(current_user)
      fake_params_redirect
      return      
    end

    @player_mjs = SidedMatchJoin.players(@sided_match)
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

    @sided_match.host_team_goal = params[:sided_match][:host_team_goal]    
    @sided_match.guest_team_goal = params[:sided_match][:guest_team_goal]      
    @sided_match.situation = params[:sided_match][:situation]

    if (!@sided_match.host_team_goal.blank? && @sided_match.host_team_goal<filled_goal_sum)
     @sided_match.errors.add_to_base("队员入球总数不能超过本队入球数")
     render :action => "edit_result", :layout=>'team_layout' 
     return
    end

    begin
      SidedMatch.transaction do
        @sided_match.save!
        raise ActiveRecord::RecordInvalid if !SidedMatchJoin.update(@match_join_hash.keys,@match_join_hash.values)
        redirect_to sided_match_path(@sided_match)
      end
    rescue ActiveRecord::RecordInvalid => e
      render :action => "edit_result", :layout=>'team_layout' 
    end
  end

  def destroy
    @sided_match = SidedMatch.find(params[:id])
    if !@sided_match.can_be_destroyed_by?(current_user) #只有比赛结束后到关闭前才可以填写比赛结果和队员比赛信息
      fake_params_redirect      
    else
      @sided_match.destroy
      redirect_to team_view_path(@sided_match.host_team_id)
    end
  end
end
