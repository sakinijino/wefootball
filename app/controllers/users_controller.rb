class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  before_filter :login_required, :only=>[:update, :edit]
  
  # render new.rhtml
  def new
  end
  
  # GET /teams/:team_id/users.xml
  # GET /trainings/:training_id/users.xml
  def index # 列出某个队伍的所有队员
    if (params[:team_id])
      @team = Team.find(params[:team_id])
      @users = @team.users
    else #训练中的所有队员
      @tr = Training.find(params[:training_id])
      @users = @tr.users
    end
  end
  
  # GET /users/search.xml?query
  def search
    @users = User.find_by_contents(params[:q]) 
  end
  
  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    params[:user][:nickname] = params[:user][:login].split('@')[0] if ( params[:user][:login]!=nil &&
      (!params[:user][:nickname] || params[:user][:nickname] == "")) 
    @user = User.new(params[:user])
    @user.save!
    self.current_user = @user
    redirect_back_or_default('/')
  end
  
  def show
    @user = User.find(params[:id], :include=>[:positions])
  end
  
   # render edit.rhtml
  def edit
    if (!param_id_is_current_user)
      fake_params_redirect
    else
      @user = User.find(params[:id], :include=>[:positions])
      @positions = @user.positions.map {|pos| pos.label}
    end
  end
  
  def update
    if (!param_id_is_current_user)
      fake_params_redirect
      return
    end
    params[:user].delete :login # login can not be modified
    @user=self.current_user
    if (params[:user][:uploaded_data]!=nil)
      update_image
      return
    end
    pre_process_player_info if params[:user][:is_playable]!=nil #update player info
    if self.current_user.update_attributes(params[:user])
      redirect_to edit_user_url(@user)
    else
      @positions = @user.positions.map {|pos| pos.label}
      render :action => "edit" 
    end
  end
  
  def update_image
    if (!param_id_is_current_user)
      fake_params_redirect
      return
    end
    @user=self.current_user
    if (@user.user_image==nil)
      @user.user_image = UserImage.new
    end
    if @user.user_image.update_attributes({:uploaded_data => params[:user][:uploaded_data]})
      @user.save
      redirect_to edit_user_url(@user)
    else
      @positions = @user.positions.map {|pos| pos.label}
      @user.user_image.reload
      render :action => "edit" 
    end
  end
  
  protected
  def param_id_is_current_user
    self.current_user.id.to_s == params[:id].to_s
  end
  
  def pre_process_player_info
    if params[:user][:is_playable] == '0' # unchecked
      params[:user][:weight] = nil
      params[:user][:height] = nil
      params[:user][:fitfoot] = nil
      params[:user][:premier_position] = nil
      params[:positions]=[]
    end
    if params[:user][:is_playable] == '1' # checked
      params[:positions]=[] if (!params[:positions]) 
      params[:positions]<<params[:user][:premier_position]
    end
    @user.positions.clear # poor performance, need refactoring
    params[:positions].uniq!
    for label in params[:positions]
      @user.positions<<Position.new({:label=>label})
    end
  end
end
