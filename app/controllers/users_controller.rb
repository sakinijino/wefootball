class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  before_filter :login_required, :only=>[:update]
  
  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new(params[:user])
    @user.save!
    self.current_user = @user
    respond_to do |format|
      format.xml {render :template=>"shared/user"}
    end
  rescue ActiveRecord::RecordInvalid
    respond_to do |format|
      format.xml { render :xml=>@user.errors.to_xml_full, :status=>400}
    end
  end
  
  def show
    @user = User.find(params[:id])
    respond_to do |format|
      format.xml {render :template=>"shared/user"}
    end
  rescue ActiveRecord::RecordNotFound => e
    respond_to do |format|
      format.xml {head 404}
    end
  end
  
  def update
    respond_to do |format|
      format.xml {
        if (self.current_user.id.to_s != params[:id])
          head 401
          return
        end
        params[:user].delete :login
        @user=self.current_user
        if self.current_user.update_attributes(params[:user])
          render :template=>"shared/user"
        else
          render :xml => @user.errors.to_xml_full, :status => 400
        end
      }
    end
  end
end
