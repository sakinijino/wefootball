class TrainingViewsController < ApplicationController

  def show
    @training = Training.find(params[:id])
    @posts = @training.posts.find(:all, :limit=>10)
  end
end
