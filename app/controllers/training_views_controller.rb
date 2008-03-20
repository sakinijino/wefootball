class TrainingViewsController < ApplicationController

  def show
    @training = Training.find(params[:id])
    @posts = @training.posts.find(:all, :limit=>10)
    @title = "#{@training.team.shortname} #{@training.start_time.strftime('%m月%d日')}的训练"
    render :layout=>'training_layout'
  end
end
