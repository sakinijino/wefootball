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
  
#  def update #重新指定管理员,并删除原有管理员的参加
#    @wj = WatchJoin.find(params[:id])
#    @watch = @wj.watch
#    @new_admin = @wj.user    
#    if (@watch.admin.id != current_user.id) || (@new_admin.id == current_user.id)
#      fake_params_redirect
#      return
#    end
#
#    @watch_join = WatchJoin.find_by_watch_id_and_user_id(@watch.id,current_user.id)   
#    @watch.admin = @new_admin    
#
#    WatchJoin.transaction do
#      @watch.save!
#      @watch_join.destroy
#    end
#    redirect_to watch_path(@watch)
#    rescue ActiveRecord::RecordInvalid => e
#      fake_params_redirect
#  end
#
#  def destroy_admin
#    @watch = Watch.find(params[:watch_id])
#    if @watch.admin.id != current_user.id
#      fake_params_redirect
#      return
#    end
#    #可能需要用缓存计数来取代
#    @wjs = WatchJoin.paginate_all_by_watch_id(
#      params[:watch_id],
#      :include=>[:user],
#      :page => params[:page], 
#      :per_page => 50
#    )
#    if @wjs.size > 1
#      @other_wjs = @wjs.reject {|wj| wj.user == current_user}
#      render :action => 'select_new_admin'
#    else
#      @watch_join = WatchJoin.find_by_watch_id_and_user_id(@watch.id,current_user.id)
#      @watch_join.destroy
#      redirect_to user_view_path(current_user)      
#    end      
#  end

  def select_new_admin
    @wjs = WatchJoin.paginate_all_by_watch_id(
      params[:watch_id],
      :include=>[:user],
      :page => params[:page], 
      :per_page => 50
    )
    @other_wjs = @wjs.reject {|wj| wj.user == current_user}    
  end
  
  def destroy_admin
    @wj = WatchJoin.find(params[:watch_join_id])
    @watch = @wj.watch
    @new_admin = @wj.user    
    if (@watch.admin.id != current_user.id) || (@new_admin.id == current_user.id)
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
