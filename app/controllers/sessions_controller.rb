# This controller handles the login/logout function of the site.  
class SessionsController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  
  def create
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      respond_to do |format|
        @user = self.current_user
        format.xml {render :template=>"shared/user"}
      end  
    else
      respond_to do |format|
        format.xml { render :text => "error" }
        
      end
    end
  end
  
  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    respond_to do |format|
      format.xml { head 200}
    end
  end
end
