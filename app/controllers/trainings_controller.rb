class TrainingsController < ApplicationController
  before_filter :login_required
  # GET /trainings
  # GET /trainings.xml
  # GET /users/:user_id/trainings.xml
  # GET /teams/:team_id/trainings.xml
  def index
    if (params[:user_id]) #显示用户参与的训练
#      @user = User.find(params[:user_id])
#      respond_to do |format|
#        @trainings = @user.trainings
#        format.xml  { render :xml => @trainings.to_xml(:dasherize=>false), :status => 200  }
#      end
    else #显示队伍的所有训练
      @team = Team.find(params[:team_id])
      respond_to do |format|
        @trainings = @team.trainings
        format.xml  { render :xml => @trainings.to_xml(:dasherize=>false), :status => 200  }
      end
    end
  rescue ActiveRecord::RecordNotFound => e
    respond_to do |format|
      format.xml {head 404}
    end
  end

  # GET /trainings/1
  # GET /trainings/1.xml
  def show
    @training = Training.find(params[:id])
    respond_to do |format|
      format.xml  { render :xml => @training.to_xml(:dasherize=>false) }
    end
  rescue ActiveRecord::RecordNotFound => e
    respond_to do |format|
      format.xml {head 404}
    end
  end

  # POST /trainings
  # POST /trainings.xml
  # POST /teams/:team_id/trainings.xml
  def create
    @team = Team.find(params[:training][:team_id])
    if (!@team.users.admin.include?(self.current_user))
      respond_to do |format|
        format.xml {head 401}
      end
      return
    end
    @training = Training.new(params[:training])
    respond_to do |format|
      if @training.save
        format.xml  { render :xml => @training.to_xml(:dasherize=>false), :status => 200, :location => @training }
      else
        format.xml  { render :xml => @training.errors.to_xml_full, :status => 200 }
      end
    end
  rescue ActiveRecord::RecordNotFound => e
    respond_to do |format|
      format.xml {head 404}
    end
  end

  # PUT /trainings/1
  # PUT /trainings/1.xml
  def update
    @training = Training.find(params[:id])
    if (!@training.team.users.admin.include?(self.current_user))
      respond_to do |format|
        format.xml {head 401}
      end
      return
    end
    params[:training].delete :team_id
    respond_to do |format|
      if @training.update_attributes(params[:training])
        format.xml  { render :xml => @training.to_xml(:dasherize=>false), :status => 200 }
      else
        format.xml  { render :xml => @training.errors.to_xml_full, :status => 200 }
      end
    end
  rescue ActiveRecord::RecordNotFound => e
    respond_to do |format|
      format.xml {head 404}
    end
  end

  # DELETE /trainings/1
  # DELETE /trainings/1.xml
  def destroy
    @training = Training.find(params[:id])
    if (!@training.team.users.admin.include?(self.current_user))
      respond_to do |format|
        format.xml {head 401}
      end
      return
    end
    @training.destroy
    respond_to do |format|
      format.xml  { head :ok }
    end
  rescue ActiveRecord::RecordNotFound => e
    respond_to do |format|
      format.xml {head 404}
    end
  end
end
