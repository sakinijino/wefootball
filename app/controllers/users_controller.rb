class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  before_filter :login_required, :only=>[:update]
  
  # GET /teams/:team_id/users.xml
  # GET /trainings/:training_id/users.xml
  def index # 列出某个队伍的所有队员
    options = default_user_to_xml_options
    options[:except]<<:summary
    if (params[:team_id])
      @team = Team.find(params[:team_id])
      respond_to do |format|
        @users = @team.users
        format.xml  { render :xml=>@users.to_xml(options), :status => 200 }
      end
    else #训练中的所有队员
      @tr = Training.find(params[:training_id])
      respond_to do |format|
        @users = @tr.users
        format.xml  { render :xml=>@users.to_xml(options), :status => 200 }
      end
    end
  rescue ActiveRecord::RecordNotFound => e
    respond_to do |format|
      format.xml {head 404}
    end
  end
  
  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    params[:user][:nickname] = params[:user][:login].split('@')[0] if ( params[:user][:login]!=nil &&
      (!params[:user][:nickname] || params[:user][:nickname] == "")) 
    @user = User.new(params[:user])
    @user.save!
    self.current_user = @user
    respond_to do |format|
      #~ @short_format = true
      format.xml {render :xml=>@user.to_xml({:dasherize=>false, :only=>['id', 'login', 'nickname']}) }
    end
  rescue ActiveRecord::RecordInvalid
    respond_to do |format|
      format.xml { render :xml=>@user.errors.to_xml_full}
    end
  end
  
  def show
    @user = User.find(params[:id], :include=>[:positions])
    respond_to do |format|
      format.xml {render :xml=>@user.to_xml(default_user_to_xml_options)}
    end
  rescue ActiveRecord::RecordNotFound => e
    respond_to do |format|
      format.xml {head 404}
    end
  end
  
  def update
    respond_to do |format|
      format.xml {
        if (self.current_user.id.to_s != params[:id].to_s)
          head 401
          return
        end
        params[:user].delete :login # login can not be modified
        @user=self.current_user
        if self.current_user.update_attributes(params[:user])
          @user.positions.clear
          params[:positions]=[] if (!params[:positions]) 
          params[:positions].uniq!
          for label in params[:positions]
            @user.positions<<Position.new({:label=>label})
          end
          @user.save
          render :xml=>@user.to_xml(default_user_to_xml_options)
        else
          render :xml => @user.errors.to_xml_full
        end
      }
    end
  end
end
