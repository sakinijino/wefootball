require File.dirname(__FILE__) + '/../test_helper'

class MessagesControllerTest < ActionController::TestCase
  def test_should_get_index
    login_as :saki
    get :index
    assert 1, assigns(:messages).length
    get :index, :as => 'sender'
    assert 2, assigns(:messages).length
  end

  def test_show_message
    login_as :saki
    get :show, :id => messages(:saki_mike1_3).id
    assert_template 'show'
    get :show, :id => messages(:saki_mike1_2).id
    assert_redirected_to '/'
    get :show, :id => messages(:mike2_saki).id
    assert_response :success
    assert_template 'show'
    get :show, :id => messages(:mike2_saki_2).id
    assert_redirected_to '/'
  end
  
  def test_should_create_message
    login_as :saki
    assert_difference('Message.count') do
      post :create, :message => {:receiver_id=>users(:mike1).id, :subject=>'hello', :content=>'hello' }
      assert_redirected_to messages_path(:as=>"sender")
    end
  end
  
  def test_should_not_send_message_to_self
    login_as :saki
    assert_no_difference('Message.count') do
      post :create, :message => {:receiver_id=>users(:saki).id, :subject=>'hello', :content=>'hello' }
      assert_redirected_to '/'
    end
  end
  
  def test_create_message_error
    login_as :saki
    assert_no_difference('Message.count') do
      post :create, :message => {:receiver_id=>users(:mike1).id, :subject=>'h'*201, :content=>'h'*3001 }
      assert_template 'new'
      assert assigns(:message).errors.on(:subject)
      assert assigns(:message).errors.on(:content)
    end
    assert_no_difference('Message.count') do
      post :create, :message => {:receiver_id=>users(:mike1).id, :subject=>'', :content=>'123' }
      assert_template 'new'
      assert assigns(:message).errors.on(:subject)
      assert assigns(:message).errors.on(:content)
    end
  end

  def test_sender_destroy_message
    login_as :mike2
    assert_no_difference('Message.count') do
      delete :destroy, :id => messages(:mike2_saki).id
      assert_redirected_to messages_path(:as=>"sender")
      assert Message.find(messages(:mike2_saki).id).is_delete_by_sender
    end
  end
  
  def test_receiver_destroy_message
    login_as :saki
    assert_no_difference('Message.count') do
      delete :destroy, :id => messages(:mike2_saki).id
      assert_redirected_to messages_path(:as=>"receiver")
      assert Message.find(messages(:mike2_saki).id).is_delete_by_receiver
    end
  end
  
  def test_both_destroy_message
    login_as :mike2
    assert_difference('Message.count', -1) do
      delete :destroy, :id => messages(:mike2_saki_2).id
      assert_redirected_to messages_path(:as=>"sender")
    end
  end
  
  def test_destroy_multi
    login_as :mike2
    assert_difference('Message.count', -1) do
      delete :destroy_multi, 
        :messages => [messages(:mike2_saki).id, messages(:mike2_saki_2).id], 
        :back_uri => '/public'
      assert Message.find(messages(:mike2_saki).id).is_delete_by_sender
    end
    assert_redirected_to '/public'
  end
  
  def test_destroy_multi_with_a_not_my_message
    login_as :mike2
    assert_no_difference('Message.count') do
      delete :destroy_multi, 
        :messages => [messages(:saki_mike1).id], 
        :back_uri => '/public'
      assert !Message.find(messages(:saki_mike1).id).is_delete_by_receiver
      assert !Message.find(messages(:saki_mike1).id).is_delete_by_sender
    end
    assert_redirected_to '/public'
  end
  
  def test_destroy_multi_with_empty_request
    login_as :mike2
    delete :destroy_multi
    assert_redirected_to messages_path
  end
end
