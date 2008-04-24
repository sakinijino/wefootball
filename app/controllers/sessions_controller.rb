class SessionsController < ApplicationController

  skip_before_filter :store_current_location
  
  def new
    render :layout => default_layout  
  end
  
  def create
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , 
          :expires => self.current_user.remember_token_expires_at }
      end
      @user = self.current_user
      redirect_back_or_default(user_view_path(@user))
    else
      @se = User.new      
      if User.correct_login_without_activation(params[:login], params[:password])
        @se.errors.add_to_base('你的帐号还没有激活, 请先登录Email完成激活操作')
        @se.errors.add_to_base(%(如果尚未收到激活邮件, 请<a href="/resend_activate_mail">点击这里</a>))
      else
        @se.errors.add_to_base('用户名或密码错误')
      end
      render :action => 'new', :layout => default_layout  
    end
  end
  
  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "你已经退出WeFootball"
    redirect_with_back_uri_or_default new_session_path
  end
end
