# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead

  # render new.rhtml
  def new
  end
  
  def create
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      respond_to do |format|
        @user = self.current_user
        format.html {
          redirect_back_or_default('/')
          flash[:notice] = "Logged in successfully"
        }
        format.xml {
          proc = Proc.new { |options| 
              options[:builder].tag!('is_my_friend', false)
          }
          render :xml=>@user.to_xml({
          :dasherize=>false,
          :except=>[:crypted_password, :salt, :created_at, :updated_at, :remember_token, :remember_token_expires_at],
          :include => [:positions],
          :procs => proc
        }) }
      end  
    else
      respond_to do |format|
        format.html {render :action => 'new'}
        format.xml { head 401 }
      end
    end
  end
  
  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    respond_to do |format|
      format.html {
        flash[:notice] = "You have been logged out."
        redirect_back_or_default('/')
      }
      format.xml { head 200}
    end
  end
end
