class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  before_filter :login_required, :only=>[:update, :edit]
  
  # render new.rhtml
  def new
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
    @user = User.new(params[:user])
    @user.login = params[:user][:login]
    if @user.save
      self.current_user = @user
      redirect_back_or_default('/')
    else
      render :action=>'new'
    end
  end
  
  def show
    @user = User.find(params[:id], :include=>[:positions, :user_image])
  end
  
   # render edit.rhtml
  def edit
    if (!param_id_is_current_user)
      fake_params_redirect
    else
      @user = User.find(params[:id], :include=>[:positions, :user_image])
      @positions = @user.positions.map {|pos| pos.label}
    end
  end
  
  def update
    if (!param_id_is_current_user)
      fake_params_redirect
      return
    end
    @user=self.current_user
    if (params[:user][:uploaded_data]!=nil)
      if update_image
        redirect_to edit_user_url(@user)
      else
        @user.user_image.errors.each do |attr, msg|
          @user.errors.add(attr, msg)
        end
        @user.user_image.reload
        @positions = @user.positions.map {|pos| pos.label}
        render :action => "edit" 
      end
    else
      pre_process_positions if params[:user][:is_playable]=="1"
      if @user.update_attributes(params[:user])
        redirect_to edit_user_url(@user)
      else
        @positions = @user.positions.map {|pos| pos.label}
        render :action => "edit" 
      end
    end
  end
  
  protected
  def param_id_is_current_user
    self.current_user.id.to_s == params[:id].to_s
  end
  
  def update_image
    @user.user_image = UserImage.find_or_initialize_by_user_id(@user.id)
    if @user.user_image.update_attributes({:uploaded_data => params[:user][:uploaded_data]})
      @user.save
    else
      false
    end
  end
  
  def pre_process_positions
    params[:positions] = [] if params[:positions]==nil
    @user.positions.clear # poor performance, need refactoring
    params[:positions].uniq!
    for label in params[:positions]
      @user.positions<<Position.new({:label=>label})
    end
  end
end
