class WatchJoinsController < ApplicationController

  before_filter :login_required
  
  def create
    @watch = Watch.find(params[:watch_id])
    if !@watch.can_be_joined_by?(current_user)
      fake_params_redirect
      return
    end    
    @watch_join = WatchJoin.create!(:watch_id=>@watch.id,:user_id=>current_user.id)
    redirect_to watch_path(@watch) 
  end
  
  def destroy_admin
    @wj = WatchJoin.find(params[:id])
    @watch = @wj.watch
    @new_admin = @wj.user    
    if !@watch.can_be_edited_by?(current_user) || (@new_admin.id == current_user.id) || !@watch.has_member?(@new_admin)
      fake_params_redirect
      return
    end

    @watch_join = WatchJoin.find_by_watch_id_and_user_id(@watch.id,current_user.id)   
    @watch.admin = @new_admin    

    WatchJoin.transaction do
      @watch.save!
      @watch_join.destroy
    end
    redirect_to watch_path(@watch)
    rescue ActiveRecord::RecordInvalid => e
      fake_params_redirect    
  end
  
  def destroy
    @watch = Watch.find(params[:watch_id])
    if !@watch.can_be_quited_by?(current_user)
      fake_params_redirect
      return
    end
    @watch_join = WatchJoin.find_by_watch_id_and_user_id(@watch.id,current_user.id)
    @watch_join.destroy
    if @watch.watch_joins.empty?
      redirect_to user_view_path(current_user)
    else
      redirect_to watch_path(@watch)
    end
  end
end
