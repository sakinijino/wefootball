require File.dirname(__FILE__) + '/../test_helper'

class MessagesControllerTest < ActionController::TestCase
  def test_should_get_index
    login_as :saki
    get :index
    assert_response :success
    assert_select 'as_sender>message', 2
    assert_select 'as_sender>message>sender_id', users(:saki).id.to_s
    assert_select 'as_receiver>message', 1
    assert_select 'as_receiver>message>receiver_id', users(:saki).id.to_s
  end

  def test_show_message
    login_as :saki
    get :show, :id => messages(:saki_mike1_3).id
    assert_response :success
    assert_select 'message>sender_id', users(:saki).id.to_s
    get :show, :id => messages(:saki_mike1_2).id
    assert_response 401
    get :show, :id => messages(:mike2_saki).id
    assert_response :success
    assert_select 'message>is_receiver_read', 'true'
    assert_select 'message>receiver_id', users(:saki).id.to_s
    get :show, :id => messages(:mike2_saki_2).id
    assert_response 401
  end
  
  def test_should_create_message
    login_as :saki
    assert_difference('Message.count') do
      post :create, :message => {:receiver_id=>users(:mike1).id, :subject=>'hello', :content=>'hello' }
      assert_response :success
      assert_select 'message>sender_id', users(:saki).id.to_s
    end
  end
  
  def test_send_message_to_self
    login_as :saki
    assert_no_difference('Message.count') do
      post :create, :message => {:receiver_id=>users(:saki).id, :subject=>'hello', :content=>'hello' }
      assert_response 400
    end
  end
  
  def test_create_message_error
    login_as :saki
    assert_no_difference('Message.count') do
      post :create, :message => {:receiver_id=>users(:mike1).id, :subject=>'h'*201, :content=>'h'*2001 }
      assert_response 200
      assert assigns(:message).errors.on(:subject)
      assert_not_nil(find_tag(:tag=>"error", :attributes=>{:field=>"subject"}))
      assert_not_nil(find_tag(:tag=>"error", :attributes=>{:field=>"content"}))
      assert assigns(:message).errors.on(:content)
    end
    assert_no_difference('Message.count') do
      post :create, :message => {:receiver_id=>users(:mike1).id, :subject=>'', :content=>'' }
      assert_response 200
      assert assigns(:message).errors.on(:subject)
      assert assigns(:message).errors.on(:content)
    end
  end

  def test_sender_destroy_message
    login_as :mike2
    assert_no_difference('Message.count') do
      delete :destroy, :id => messages(:mike2_saki).id
      assert_response 200
      assert Message.find(messages(:mike2_saki).id).is_delete_by_sender
    end
  end
  
  def test_receiver_destroy_message
    login_as :saki
    assert_no_difference('Message.count') do
      delete :destroy, :id => messages(:mike2_saki).id
      assert_response 200
      assert Message.find(messages(:mike2_saki).id).is_delete_by_receiver
    end
  end
  
  def test_both_destroy_message
    login_as :saki
    assert_no_difference('Message.count', -1) do
      delete :destroy, :id => messages(:mike2_saki_2).id
      assert_response 200
    end
  end
end
