class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  before_filter :login_required, :only=>[:update, :edit]
  before_filter :param_id_should_be_current_user, :only=>[:update, :update_image, :edit]

  def activate
    self.current_user = params[:activation_code].blank? ? :false : User.find_by_activation_code(params[:activation_code])
    if logged_in? && !current_user.active?
      current_user.activate
      flash[:notice] = "注册完毕！"
      redirect_to edit_user_path(current_user)
    else
      fake_params_redirect
    end
  end
  
  def forgot_password
    if request.post?
      user = User.find_by_login(params[:user][:login])
      if user        
        user.create_password_reset_code     
        UserMailer.deliver_forgot_password(user)        
        flash[:notice] = "密码重设通知已经发送到了#{user.login}，请查收"       
      else      
        flash[:notice] = "目前并无#{params[:user][:login]}所对应的帐户"  
      end     
      redirect_to(new_session_path) 
    end 
  end 
  
  def reset_password
    @user = nil
    @user = User.find_by_password_reset_code(params[:password_reset_code]) unless params[:password_reset_code].blank? 
    if @user.nil?
      fake_params_redirect
      return
    end
    if request.post?
      @user.password = params[:user][:password]
      @user.password_confirmation = params[:user][:password_confirmation]
      if @user.save
        self.current_user = @user    
        @user.delete_password_reset_code
        UserMailer.deliver_reset_password(@user)          
        flash[:notice] = "帐户#{@user.login}的密码已经更改成功"    
        redirect_to(new_session_path)   
      else   
        render :action => :reset_password   
      end  
    end 
  end  
  
  def new
  end
  
  def search
    @users = User.find_by_contents(params[:q]) 
  end
  
  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.find_by_login_and_activated_at(params[:user][:login],nil)
    if @user
      @user.password = params[:user][:password]
      @user.password_confirmation = params[:user][:password_confirmation]       
    else
      @user = User.new(params[:user])
      @user.login = params[:user][:login]
    end
    if @user.save
      UserMailer.deliver_signup_notification(@user)
      flash[:notice] = "您的帐户已经注册成功，请登录您的注册邮箱（ #{@user.login}）激活帐户"    
      redirect_to(new_session_path)      
    else
      render :action=>'new'
    end
  end
  
  def edit
    @user = User.find(params[:id], :include=>[:positions])
    @positions = @user.positions_array
    @title = "修改个人信息"
    render :layout => "user_layout"
  end
  
  def update
    @user=self.current_user
    @user.positions_array=params[:positions] if params[:user][:is_playable]=="1"
    if @user.update_attributes(params[:user])
      redirect_to edit_user_path(@user)
    else
      @positions = @user.positions_array
      render :action => "edit", :layout => "user_layout"
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
      render :action => "edit", :layout => "user_layout"
    end
  end
  
  protected
  def param_id_should_be_current_user
    fake_params_redirect if self.current_user.id.to_s != params[:id].to_s
  end
end
