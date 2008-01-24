class MessagesController < ApplicationController
  # GET /messages
  # GET /messages.xml
  def index
    @as_sender_messages = Message.find_all_by_sender_id_and_is_delete_by_sender(current_user.id,false)
    @as_receiver_messages = Message.find_all_by_receiver_id_and_is_delete_by_receiver(current_user.id,false)    

    respond_to do |format|
      format.xml  { render :status => 200, :template=>"shared/requests_with_messages" }
    end
  end

  # GET /messages/1
  # GET /messages/1.xml
  def show
    @message = Message.find(params[:id])

    respond_to do |format|
      proc = Proc.new { |options| 
          options[:builder].tag!('sender_nick', @message.sender.nickname)
          options[:builder].tag!('receiver_nick', @message.receiver.nickname)}
      format.xml  { render :xml => @message.to_xml(:dasherize=>false ,:procs => [ proc] )}
    end
  end

  # POST /messages
  # POST /messages.xml
  def create
    @message = Message.new(params[:message])

    respond_to do |format|
      if @message.save
        format.xml  { render :xml => @message.to_xml(:dasherize=>false), :status => :ok, :location => @message }
      else
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /messages/1
  # PUT /messages/1.xml
  def update
    @message = Message.find(params[:id])

    respond_to do |format|
      if @message.update_attributes(params[:message])
        format.xml  { head :ok }
      else
        format.xml  { render :xml => @message.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /messages/1
  # DELETE /messages/1.xml
  def destroy
    @message = Message.find(params[:id])
    
    if(@message.sender_id == @message.receiver_id)
      @message.destroy
    elsif((@message.sender_id == current_user.id )&& (@message.is_delete_by_receiver == false))
      @message.is_delete_by_sender = true
      @message.save
    elsif((@message.sender_id == current_user.id) && (@message.is_delete_by_receiver == true))
      @message.destroy
    elsif(@message.receiver_id == current_user.id && @message.is_delete_by_sender == false)
      @message.is_delete_by_receiver = true
      @message.save
    elsif(@message.receiver_id == current_user.id && @message.is_delete_by_sender == true)
      @message.destroy
    end

    respond_to do |format|
      format.xml  { head :ok }
    end
  end
end
