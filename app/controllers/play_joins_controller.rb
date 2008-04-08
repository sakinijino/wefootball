class PlayJoinsController < ApplicationController
  
  before_filter :login_required

  def create
    @play = Play.find(params[:play_id])
    if !@play.can_be_joined_by?(current_user)
      fake_params_redirect
      return
    end    
    @play_join = PlayJoin.create!(:play_id=>@play.id,:user_id=>current_user.id)
    redirect_to play_path(@play) 
  end

  def destroy
    @play = Play.find(params[:play_id])
    if !@play.can_be_unjoined_by?(current_user)
      fake_params_redirect
      return
    end
    @play_join = PlayJoin.find_by_play_id_and_user_id(@play.id,current_user.id)
    Play.transaction do
      @play_join.destroy
      if @play.play_joins.empty?
        redirect_to user_view_path(current_user)
        return
      else
        redirect_to play_path(@play)
        return
      end
    end
  end
  
end
