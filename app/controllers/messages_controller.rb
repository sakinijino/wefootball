class MessagesController < ApplicationController
  layout "user_layout"
  
  before_filter :login_required
  before_filter :receiver_can_not_be_current_user, :only=>[:new, :create]
  
  def index
    @user = current_user
    @title = params[:as]=='sender' ? "我的发件箱" : "我的收件箱"
    @messages = params[:as]=='sender' ? 
      Message.find_all_by_sender_id_and_is_delete_by_sender(current_user.id, false, 
        :include=>[:receiver], :order => 'messages.created_at desc') :
      Message.find_all_by_receiver_id_and_is_delete_by_receiver(current_user.id, false, 
        :include=>[:sender], :order => 'messages.created_at desc')
  end

  def show
    @user = current_user
    @message = Message.find(params[:id], :include=>[:sender, :receiver])
    if (!@message.can_read_by?(self.current_user))
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
    @message = Message.new
    @message.receiver = @receiver
    @title = "给#{@receiver.nickname}写信"
  end

  def create
    @receiver = User.find(params[:message][:receiver_id])
    @message = Message.new(params[:message])
    @message.receiver = @receiver
    @message.sender = self.current_user
    if @message.save
      redirect_to messages_path(:as=>"sender")
    else
      @user = current_user
      render :action=>"new"
    end
  end

  def destroy
    @message = Message.find(params[:id])
    if(@message.sender_id == self.current_user.id )
      as = 'sender'
    elsif (@message.receiver_id == self.current_user.id)
      as = 'receiver'
    else
      fake_params_redirect
    end
    @message.destroy_by!(current_user)
    redirect_to messages_path(:as=>as)
  end
  
  def destroy_multi
    if params[:messages] != nil
      @messages = Message.find(params[:messages])
      @messages.each do |m|
        m.destroy_by!(current_user)
      end
    end
    redirect_with_back_uri_or_default messages_path
  end
  
protected
  def receiver_can_not_be_current_user
    fake_params_redirect if (params[:to].to_s == self.current_user.id.to_s ||
        (params[:message]!=nil && params[:message][:receiver_id].to_s == self.current_user.id.to_s))
  end
end
