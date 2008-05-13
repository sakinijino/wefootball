class OfficalMatchesController < ApplicationController
  before_filter :login_required, :except => [:show, :index]
  before_filter :require_editor, :except => [:show, :index]

  def show
    @offical_match = OfficalMatch.find(params[:id])
    @is_editor = OfficalMatchEditor.is_a_editor?(current_user)
  end

  def new
    @offical_match = OfficalMatch.new
    @offical_match.start_time = Time.now
    render :layout => default_layout
  end

  def edit
    @offical_match = OfficalMatch.find(params[:id])
  end

  def create
    @offical_match = OfficalMatch.new(params[:offical_match])
    @offical_match.user = current_user
    if @offical_match.save
      redirect_to(@offical_match)
    else
      render :action => "new"
    end
  end

  def update
    @offical_match = OfficalMatch.find(params[:id])

    if @offical_match.update_attributes(params[:offical_match])
      flash[:notice] = 'OfficalMatch was successfully updated.'
      redirect_to(@offical_match)
    else
      render :action => "edit"
    end
  end

  def destroy
    @offical_match = OfficalMatch.find(params[:id])
    @offical_match.destroy
    redirect_to(offical_matches_url)
  end
  
  private
  def require_editor
    fake_params_redirect if !OfficalMatchEditor.is_a_editor?(current_user)
  end
end
