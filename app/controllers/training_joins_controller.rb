class TrainingJoinsController < ApplicationController
  before_filter :login_required
  
  def create
    @training = Training.find(params[:training_id])
    if (@training.has_member?(current_user))
      redirect_to training_view_path(@training)
    elsif (!@training.can_be_joined_by?(current_user))
      fake_params_redirect
    else
      @training_join = TrainingJoin.create(:user_id=>current_user.id, :training_id=>params[:training_id])
      redirect_to training_view_path(@training)
    end
  end

  def destroy
    TrainingJoin.destroy_all(["user_id = ? and training_id = ?", current_user.id, params[:training_id]])
    redirect_to training_view_path(params[:training_id])
  end
end
