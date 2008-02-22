class TrainingViewsController < ApplicationController

  def show
    @training = Training.find(params[:id], :include=>[:team, :users])
  end
end
