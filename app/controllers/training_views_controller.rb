class TrainingViewsController < ApplicationController

  def show
    @training = Training.find(params[:id])
    @posts = @training.posts.find(:all, :limit=>10)
    @team = @training.team
    @title = "#{@training.team.shortname} #{@training.start_time.strftime('%m.%d')}的训练"
    render :layout=>'training_layout'
  end
end
