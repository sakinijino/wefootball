class TrainingJoinsController < ApplicationController
  before_filter :login_required
  
  def create
    @training = Training.find(params[:training_id])
    if (@training.has_joined_member?(current_user))
      redirect_to training_view_path(@training)
    elsif (!@training.can_be_joined_by?(current_user))
      fake_params_redirect
    else
      @training_join = TrainingJoin.find_or_initialize_by_user_id_and_training_id(current_user.id, params[:training_id])
      @training_join.status = TrainingJoin::JOIN
      @training_join.save!
      redirect_to training_view_path(@training)
    end
  end

  def destroy
    @training = Training.find(params[:training_id])
    if (!@training.can_be_quited_by?(current_user))
      fake_params_redirect
    else
      TrainingJoin.destroy_all(["user_id = ? and training_id = ?", current_user.id, params[:training_id]])
      redirect_to training_view_path(params[:training_id])
    end
  end
end
