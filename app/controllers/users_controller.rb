class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  before_filter :login_required, :only=>[:update, :edit]
  before_filter :param_id_should_be_current_user, :only=>[:update, :edit]
  
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
  
   # render edit.rhtml
  def edit
    @user = User.find(params[:id], :include=>[:positions, :user_image])
    @positions = @user.positions.map {|pos| pos.label}
  end
  
  def update
    @user=self.current_user
    update_image if (params[:user][:uploaded_data]!=nil)
    @user.positions_array=params[:positions] if params[:user][:is_playable]=="1"
    if @user.update_attributes(params[:user])
      @user.user_image.save if params[:user][:uploaded_data]!=nil && @user.user_image!=nil
      redirect_to edit_user_url(@user)
    else
      @positions = @user.positions.map {|pos| pos.label}
      @user.user_image.reload if @user.user_image!=nil && @user.user_image.errors.length > 0
      render :action => "edit" 
    end
  end
  
protected
  def param_id_should_be_current_user
    fake_params_redirect if self.current_user.id.to_s != params[:id].to_s
  end
  
  def update_image
    @user.user_image = UserImage.find_or_initialize_by_user_id(@user.id)
    @user.user_image.uploaded_data = params[:user][:uploaded_data]
  end
end
