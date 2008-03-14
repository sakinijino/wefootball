class MessagesController < ApplicationController
  layout "user_layout"
  
  before_filter :login_required
  before_filter :receiver_can_not_be_current_user, :only=>[:new, :create]
  
  # GET /messages
  def index
    @user = current_user
    @title = params[:as]=='sender' ? "#{@user.nickname}的发件箱" : "#{@user.nickname}的收件箱"
    @messages = params[:as]=='sender' ? 
      Message.find_all_by_sender_id_and_is_delete_by_sender(current_user.id, false, :include=>[:sender, :receiver]) :
      Message.find_all_by_receiver_id_and_is_delete_by_receiver(current_user.id, false, :include=>[:sender, :receiver])
  end

  # GET /messages/1
  def show
    @user = current_user
    @message = Message.find(params[:id], :include=>[:sender, :receiver])
    if (!@message.can_read_by(self.current_user))
      fake_params_redirect
      return
    end
    if (!@message.is_receiver_read && @message.receiver_id == self.current_user.id)
      @message.is_receiver_read = true
      @message.save
    end
  end
  
  def new
    @user = current_user
    @receiver = User.find(params[:to])
  end

  # POST /messages
  def create
    @receiver = User.find(params[:message][:receiver_id])
    @message = Message.new(params[:message])
    @message.sender = self.current_user
    if @message.save
      redirect_to messages_path(:as=>"sender")
    else
      @user = current_user
      render :action=>"new"
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.xml
  def destroy
    @message = Message.find(params[:id])
    as = 'receiver'
    if(@message.sender_id == current_user.id )
        @message.is_delete_by_sender = true
        as = 'sender'
    elsif (@message.receiver_id == current_user.id)
        @message.is_delete_by_receiver = true
    else
      fake_params_redirect
    end
    (@message.is_delete_by_sender && @message.is_delete_by_receiver) ? @message.destroy : @message.save
    redirect_to messages_path(:as=>as)
  end
  
protected
  def receiver_can_not_be_current_user
    fake_params_redirect if (params[:to].to_s == self.current_user.id.to_s ||
        (params[:message]!=nil && params[:message][:receiver_id].to_s == self.current_user.id.to_s))
  end
end
