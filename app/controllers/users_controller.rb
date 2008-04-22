class UsersController < ApplicationController
  skip_before_filter :store_current_location
  before_filter :clear_store_location
  
  before_filter :login_required, :only=>[:update, :edit, :invite]
  before_filter :param_id_should_be_current_user, :only=>[:update, :update_image, :edit]
  
  def activate
    self.current_user = params[:activation_code].blank? ? :false : User.find_by_activation_code(params[:activation_code])
    if logged_in? && !current_user.active?
      current_user.activate
      
      @req = FriendInvitation.find_by_applier_id(current_user)
      if @req
        FriendRelation.transaction do
          @friend_relation = FriendRelation.new
          @friend_relation.user1_id = @req.applier_id
          @friend_relation.user2_id = @req.host_id
          @friend_relation.save!
          @req.destroy
        end
      end
      flash[:notice] = "你的帐号已经激活, 现在请设置一下个人信息"
      redirect_to edit_user_path(current_user)
    else
      fake_params_redirect
    end
  end
  
  def forgot_password
    if request.post?
      user = User.find_by_login(params[:user][:login], :conditions=>"activated_at is not null")
      if user        
        user.create_password_reset_code     
        UserMailer.deliver_forgot_password(user)        
        flash[:notice] = "密码重设通知已经发送到了#{user.login}, 请查收"       
      else      
        flash[:notice] = "目前并无#{params[:user][:login]}所对应的帐户"  
      end     
      redirect_to(new_session_path) 
    else
      render :layout => 'unlogin_layout'
    end
  end 
  
  def reset_password
    @user = nil
    @user = User.find_by_password_reset_code(params[:password_reset_code], :conditions=>"activated_at is not null") unless params[:password_reset_code].blank? 
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
        redirect_to user_view_path(@user)
        return
      else   
        render :action => :reset_password, :layout=>'unlogin_layout'
        return        
      end 
    end
    render :layout => 'unlogin_layout'
  end  
  
  def new
    render :layout => default_layout  
  end
  
  def search
    if !params[:q].blank?
      @users = User.find_by_contents(params[:q], :conditions=>"activated_at is not null")
      @title = "搜索“#{params[:q]}”的结果"
    end
    render :layout=>default_layout
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
      flash[:notice] = "激活帐户的邮件已发送, 请到你的邮箱激活"
      redirect_to(new_session_path)
    else
      render :action=>'new', :layout => 'unlogin_layout'  
    end
  end
  
  def invite
    if request.post?
      @has_joined_user = User.find_by_login(params[:register_invitation][:login], :conditions=>"activated_at is not null")
      if @has_joined_user        
        @has_joined_notice = true
        @has_joined_user_id = @has_joined_user.id
        @register_invitation = RegisterInvitation.new
      else      
        @register_invitation = RegisterInvitation.new(params[:register_invitation])
        @register_invitation.host_id = current_user.id
        if @register_invitation.save
          @register_invitation.create_invitation_code
          UserMailer.deliver_invite_notification(current_user, @register_invitation, params[:message])
          flash[:notice] = "您发给#{@register_invitation.login}的邀请已送出"
          redirect_to invite_users_path
          return
        end
      end
    else
      @register_invitation = RegisterInvitation.new
    end
    @user = current_user
    render :layout => 'user_layout'    
  end

  def new_with_invitation
    @invitation = RegisterInvitation.find_by_invitation_code(params[:invitation_code])
    if @invitation.nil?
      fake_params_redirect
      return
    end
    @user = User.new
    @user.login = @invitation.login
    render :layout => 'unlogin_layout' 
  end

  def create_with_invitation
    cookies.delete :auth_token    
    @register_invitation = RegisterInvitation.find_by_invitation_code(params[:user][:invitation_code])
    if @register_invitation.nil?
      fake_params_redirect
      return
    end    
    @user = User.find_by_login_and_activated_at(params[:user][:login],nil)
    if @user #已创建，但还没有激活过
      @user.password = params[:user][:password]
      @user.password_confirmation = params[:user][:password_confirmation]       
    else
      @user = User.new(params[:user])
      @user.login = params[:user][:login]
      fi = FriendInvitation.new(:host_id=>@register_invitation.host_id, :applier_id=>@user.id)      
    end
    User.transaction do
      @user.save!
      fi.save! if fi
      RegisterInvitation.destroy(@register_invitation)
      UserMailer.deliver_signup_notification(@user)
      flash[:notice] = "您的帐户已经注册成功, 请登录您注册的Email (#{@user.login})激活帐户"
      redirect_to(new_session_path)
      return
    end
  rescue ActiveRecord::RecordInvalid => e
      render :action=>'new', :layout => default_layout    
  end  
  
  def edit
    @user = User.find(params[:id], :include=>[:positions], :conditions=>"activated_at is not null")
    @user.birthday = Date.new(1980, 1, 1) if @user.birthday == nil
    @positions = @user.positions_array
    @title = "修改我的信息"
    render :layout => "user_layout"
  end
  
  def update
    @user=self.current_user
    @user.positions_array=params[:positions] if params[:user][:is_playable]=="1"
    if @user.update_attributes(params[:user])
      flash[:notice] = "信息已保存"
      redirect_to edit_user_path(@user)
    else
      @title = "修改我的信息"
      @positions = @user.positions_array
      render :action => "edit", :layout => "user_layout"
    end
  end
  
  def update_image
    @user=self.current_user
    user_image = UserImage.find_or_initialize_by_user_id(@user.id)
    user_image.uploaded_data = params[:user][:uploaded_data]
    if user_image.save
      flash[:notice] = "头像已上传, 如果头像一时没有更新, 多刷新几次页面"
      redirect_to edit_user_path(@user)
    else
      @title = "修改我的信息"
      @positions = @user.positions_array
      @user.errors.add_to_base('上传的必须是一张图片, 而且大小不能超过2M') if !user_image.errors.empty?
      render :action => "edit", :layout => "user_layout"
    end
  end
  
  protected
  def param_id_should_be_current_user
    fake_params_redirect if self.current_user.id.to_s != params[:id].to_s
  end
end
