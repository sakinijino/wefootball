class MessagesController < ApplicationController
  # GET /messages
  # GET /messages.xml
  def index
    @as_sender_messages = Message.find_all_by_sender_id_and_is_delete_by_sender(current_user.id,false)
    @as_receiver_messages = Message.find_all_by_receiver_id_and_is_delete_by_receiver(current_user.id,false)    

    respond_to do |format|
      format.html # index.html.erb
      #format.xml  { render :xml => @messages.to_xml(:dasherize=>false) }
      format.xml  { render :status => 200, :template=>"shared/requests_with_messages" }
    end
  end

  # GET /messages/1
  # GET /messages/1.xml
  def show
    @message = Message.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @message.to_xml(:dasherize=>false) }
    end
  end

  # GET /messages/new
  # GET /messages/new.xml
  def new
    @message = Message.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @message.to_xml(:dasherize=>false) }
    end
  end

  # GET /messages/1/edit
  def edit
    @message = Message.find(params[:id])
  end

  # POST /messages
  # POST /messages.xml
  def create
    @message = Message.new(params[:message])

    respond_to do |format|
      if @message.save
        flash[:notice] = 'Message was successfully created.'
        format.html { redirect_to(@message) }
        format.xml  { render :xml => @message.to_xml(:dasherize=>false), :status => :ok, :location => @message }
      else
        format.html { render :action => "new" }
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
        flash[:notice] = 'Message was successfully updated.'
        format.html { redirect_to(@message) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
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
      format.html { redirect_to(messages_url) }
      format.xml  { head :ok }
    end
  end
end
