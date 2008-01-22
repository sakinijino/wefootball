class TrainingJoinsController < ApplicationController
  before_filter :login_required
  # POST /training_joins
  # POST /training_joins.xml
  # POST /users/:user_id/trainings/:training_id/training_joins.xml
  def create
    @training = Training.find(params[:training_join][:training_id])
    if (params[:training_join][:user_id].to_s != self.current_user.id.to_s || !@training.team.users.include?(self.current_user))
      respond_to do |format| 
        format.xml {head 401}
      end
      return
    end
    if (@training.already_join?(self.current_user))
      respond_to do |format|
        format.xml {head 200}
      end
      return
    end
    @training_join = TrainingJoin.new(params[:training_join])
    respond_to do |format|
      if @training_join.save
        format.xml  { render :xml => @training_join, :status => 200 }
      else
        format.xml  { render :xml => @training_join.errors.to_xml_full, :status => 200 }
      end
    end
  rescue ActiveRecord::RecordNotFound => e
    respond_to do |format|
      format.xml {head 404}
    end
  end

  # DELETE /training_joins/1
  # DELETE /training_joins/1.xml
  # DELETE /users/:user_id/trainings/:training_id/training_joins/0.xml
  def destroy
    if (params[:user_id].to_s != self.current_user.id.to_s)
      respond_to do |format|
        format.xml {head 401}
      end
      return
    end
    @training_join = TrainingJoin.find_by_user_id_and_training_id(params[:user_id], params[:training_id])
    @training_join.destroy
    respond_to do |format|
      format.xml  { head :ok }
    end
  rescue ActiveRecord::RecordNotFound => e
    respond_to do |format|
      format.xml {head 404}
    end
  end
end
