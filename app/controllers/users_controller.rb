class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  
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
      format.xml { render :xml=>@user.errors.to_xml_full, :status=>:unprocessable_entity}
    end
  end
end
