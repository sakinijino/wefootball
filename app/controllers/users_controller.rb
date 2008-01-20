class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  
  
  # render new.rhtml
  def new
  end
  
  # Once we explain REST in the book this will obviously be
  # refactored.
  def create_xml
    @user = User.new(params[:user])
    @user.save!
    self.current_user = @user
    render :xml => @user.to_xml
  rescue ActiveRecord::RecordInvalid
    render :text => "error"
  end
  
  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new(params[:user])
    @user.save!
    self.current_user = @user
    redirect_back_or_default('/')
    flash[:notice] = "Thanks for signing up!"
  rescue ActiveRecord::RecordInvalid
    render :action => 'new'
  end
  
end
