class TrainingViewsController < ApplicationController

  def show
    @match = Match.find(params[:id])
    #这里还缺post
  end
end
