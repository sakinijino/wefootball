class MessagesController < ApplicationController
  before_filter :login_required
  # GET /messages
  # GET /messages.xml
  def index
    if (params[:as]=='sender')
      @messages = Message.find_all_by_sender_id_and_is_delete_by_sender(current_user.id, false, :include=>[:sender, :receiver])
    else 
      @messages = Message.find_all_by_receiver_id_and_is_delete_by_receiver(current_user.id, false, :include=>[:sender, :receiver])
    end
  end

  # GET /messages/1
  # GET /messages/1.xml
  def show
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
    @receiver = User.find(params[:to])
    if (@receiver == self.current_user) 
      fake_params_redirect
      return
    end
  end

  # POST /messages
  # POST /messages.xml
  def create
    @receiver = User.find(params[:message][:receiver_id])
    if (@receiver == self.current_user) 
      fake_params_redirect
      return
    end
    @message = Message.new(params[:message])
    @message.sender = self.current_user
    if @message.save
      redirect_to messages_path(:as=>"sender")
    else
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
end
