class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  before_filter :login_required, :only=>[:update, :edit]
  before_filter :param_id_should_be_current_user, :only=>[:update, :update_image, :edit]
  
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
      #redirect_back_or_default('/')
      redirect_to user_view_path(@user)
    else
      render :action=>'new'
    end
  end
  
   # render edit.rhtml
  def edit
    @user = User.find(params[:id], :include=>[:positions, :user_image])
    @positions = @user.positions_array
  end
  
  def update
    @user=self.current_user
    @user.positions_array=params[:positions] if params[:user][:is_playable]=="1"
    if @user.update_attributes(params[:user])
      redirect_to edit_user_path(@user)
    else
      @positions = @user.positions_array
      render :action => "edit" 
    end
  end
  
  def update_image
    @user=self.current_user
    user_image = UserImage.find_or_initialize_by_user_id(@user.id)
    user_image.uploaded_data = params[:user][:uploaded_data]
    if user_image.save
      redirect_to edit_user_path(@user)
    else
      @positions = @user.positions_array
      @user.errors.add_to_base('上传的必须是一张图片，而且大小不能超过2M') if !user_image.errors.empty?
      render :action => "edit" 
    end
  end
  
protected
  def param_id_should_be_current_user
    fake_params_redirect if self.current_user.id.to_s != params[:id].to_s
  end
end
