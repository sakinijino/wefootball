require File.dirname(__FILE__) + '/../test_helper'
require 'users_controller'

# Re-raise errors caught by the controller.
class UsersController; def rescue_action(e) raise e end; end

class UsersControllerTest < Test::Unit::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead
  # Then, you can remove it from this and the units test.
  include AuthenticatedTestHelper

  fixtures :users

  def setup
    @controller = UsersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_allow_signup
    assert_difference 'User.count' do
      create_user
      get :activate, :activation_code => assigns(:user).activation_code
      assert 'sakinijino@gmail.com', assigns["user"].login
      assert_redirected_to edit_user_path(assigns(:user))
    end
  end

  def test_should_require_login_on_signup
    assert_no_difference 'User.count' do
      create_user(:login => nil)
      assert assigns(:user).errors.on(:login)
      assert_template "new"
    end
  end
  
  def test_login_should_be_an_email_on_signup
    assert_no_difference 'User.count' do
      create_user(:login => 'saki')
      assert assigns(:user).errors.on(:login)
      assert_template "new"
    end
  end

  def test_should_require_password_on_signup
    assert_no_difference 'User.count' do
      create_user(:password => nil)
      assert assigns(:user).errors.on(:password)
      assert_template "new"
    end
  end

  def test_should_require_password_confirmation_on_signup
    assert_no_difference 'User.count' do
      create_user(:password_confirmation => nil)
      assert assigns(:user).errors.on(:password_confirmation)
      assert_template "new"
    end
  end  

  def test_should_allow_signup_with_invitation
    assert_difference 'User.count' do
      login_as :saki
      create_user_with_invitation
      get :activate, :activation_code => assigns(:user).activation_code
      assert 'sakinijino@gmail.com', assigns["user"].login
      assert_redirected_to edit_user_path(assigns(:user))
    end
  end

  def test_should_require_login_on_signup_with_invitation
    assert_no_difference 'User.count' do
      login_as :saki
      create_user_with_invitation(:login => nil)
      assert assigns(:user).errors.on(:login)
      assert_template "new_with_invitation"
    end
  end
 
  def test_login_should_be_an_email_on_signup_with_invitation
    assert_no_difference 'User.count' do
      login_as :saki
      create_user_with_invitation(:login => 'saki')
      assert assigns(:user).errors.on(:login)
      assert_template "new_with_invitation"
    end
  end

  def test_should_require_password_on_signup_with_invitation
    assert_no_difference 'User.count' do
      login_as :saki
      create_user_with_invitation(:password => nil)
      assert assigns(:user).errors.on(:password)
      assert_template "new_with_invitation"
    end
  end
  
  def test_should_require_password_confirmation_on_signup_with_invitation
    assert_no_difference 'User.count' do
      login_as :saki
      create_user_with_invitation(:password_confirmation => nil)
      assert assigns(:user).errors.on(:password_confirmation)
      assert_template "new_with_invitation"
    end
  end  
  
  def test_update_success
    login_as :saki
    put :update, :id=>3, :user=>{:summary=>'Yada!!', :is_playable=>"1", :premier_position => 1}, :positions=>[1, 5]
    assert_equal 'Yada!!', assigns(:user).summary
    assert_equal 2, assigns(:user).positions.length
    assert_redirected_to edit_user_url(assigns(:user))
    put :update, :id=>3, :user=>{:is_playable=>"1"}
    assert_equal 1, assigns(:user).positions.length
    assert_equal 1, assigns(:user).premier_position
    assert_redirected_to edit_user_url(assigns(:user))
    put :update, :id=>3, :user=>{:is_playable=>"0"}, :positions=>[2, 3]
    assert_equal 0, assigns(:user).positions.length
    assert_redirected_to edit_user_url(assigns(:user))
  end
  
  def test_update_error
    login_as :quentin
    put :update, :id=>1, :user=>{:password=>'111111', :password_confirmation => '123'}
    assert assigns(:user).errors.on(:password)
    assert_template "edit"
  end
  
  def test_should_login_before_update_user
    put :update, :id=>1
    assert_redirected_to new_session_path
  end
  
  def test_should_not_update_other_user
    login_as :quentin
    put :update, :id=>2, :user=>{:nickname=>'saki@gmail.com'}
    assert_fake_redirected
  end
  
  def test_should_not_update_image_of_other_user
    login_as :quentin
    put :update_image, :id=>2, :user=>{}
    assert_fake_redirected
  end
  
  def test_should_not_get_edit_page_of_other_user
    login_as :quentin
    get :edit, :id=>2
    assert_fake_redirected
  end
  
  def test_should_sign_up_user_with_activation_code
    create_user
    assigns(:user).reload
    assert_not_nil assigns(:user).activation_code
  end

  def test_signup_user_with_invitation_should_have_an_activation_code
    login_as :saki
    create_user_with_invitation
    assigns(:user).reload
    assert_not_nil assigns(:user).activation_code
  end

  def test_should_activate_user
    create_user
    assert_nil User.authenticate(assigns(:user).login, 'quire')
    get :activate, :activation_code => assigns(:user).activation_code
    assert_redirected_to edit_user_path(assigns(:user))
    assert_equal assigns(:user), User.authenticate(assigns(:user).login, 'quire')
  end

  def test_should_activate_user
    login_as :saki
    create_user_with_invitation
    assert_nil User.authenticate(assigns(:user).login, 'quire')
    get :activate, :activation_code => assigns(:user).activation_code
    assert_redirected_to edit_user_path(assigns(:user))
    assert_equal assigns(:user), User.authenticate(assigns(:user).login, 'quire')
  end
  
  def test_should_not_activate_user_without_key
    get :activate
    assert_fake_redirected
  end

  def test_should_not_activate_user_with_blank_key
    get :activate, :activation_code => ''
    assert_fake_redirected
  end 
     
  def test_should_not_invite_without_login
    get :invite
    assert_redirected_to new_session_path 
    post :invite
    assert_redirected_to new_session_path     
  end
  
  def test_should_not_invite #测试邀请一个已注册且已激活用户的情况
    login_as :saki
    post :invite, :register_invitation=>{:login=>users(:quentin).login}
    assert_equal true, assigns(:has_joined_notice)
    assert_equal users(:quentin).id, assigns(:has_joined_user_id)    
  end

  def test_should_invite
    login_as :saki
    t1 = Team.create(:shortname=>'test1',:city=>1)
    t2 = Team.create(:shortname=>'test2',:city=>2)
    assert_not_nil t1
    assert_not_nil t2    
    #在夹具中，saki参加了3支队，其中在2支队中为管理员
    assert_no_difference('UnRegTeamInv.count',users(:saki).teams.admin.length) do
      post :invite, :register_invitation=>{:login=>"aa@bb.cc"}, :teams_id=>[t1.id,t2.id]
    end
    assert_difference('UnRegTeamInv.count',users(:saki).teams.admin.length) do
      post :invite, :register_invitation=>{:login=>"aa@bb.cc"}, :teams_id=>(users(:saki).teams.admin.map{|item| item.id}+[t1.id,t2.id])
    end    
    assert_difference('UnRegTeamInv.count',users(:saki).teams.admin.length) do
      post :invite, :register_invitation=>{:login=>"aa@bb.cc"}, :teams_id=>(users(:saki).teams.admin.map{|item| item.id})
    end
    assert_difference('UnRegTeamInv.count',users(:saki).teams.admin.length-1) do
      post :invite, :register_invitation=>{:login=>"aa@bb.cc"}, :teams_id=>(users(:saki).teams.admin.map{|item| item.id}[1..users(:saki).teams.admin.length-1])
    end    
    post :invite, :register_invitation=>{:login=>"aa@bb.cc"}, :teams_id=>(users(:saki).teams.admin.map{|item| item.id})    
    reg_inv = RegisterInvitation.find(assigns(:register_invitation))
    assert_equal "aa@bb.cc", reg_inv.login
    un_reg_fri_inv = UnRegFriendInv.find_by_invitation_id(assigns(:register_invitation))
    assert_equal users(:saki).id, un_reg_fri_inv.host_id    
    assert_redirected_to invite_users_path
    
    #测试邀请一个已注册但尚未激活用户的情况
    users(:quentin).activated_at = nil
    users(:quentin).save!
    post :invite, :register_invitation=>{:login=>users(:quentin).login}, :teams_id=>(users(:saki).teams.admin.map{|item| item.id})    
    reg_inv = RegisterInvitation.find(assigns(:register_invitation))
    assert_equal users(:quentin).login, reg_inv.login
    un_reg_fri_inv = UnRegFriendInv.find_by_invitation_id(assigns(:register_invitation))
    assert_equal users(:saki).id, un_reg_fri_inv.host_id     
    assert_redirected_to invite_users_path    
  end
  
  #未邀请未注册未激活
  def test_invite_a_not_invited_and_not_created_and_not_activated_user
    login_as :saki
    friend_email = "aa@bb.cc"
    friend_password = "111111"
    post :invite, :register_invitation=>{:login=>friend_email}, :teams_id=>(users(:saki).teams.admin.map{|item| item.id})
    inv_code = assigns(:register_invitation).invitation_code
    post :create_with_invitation, :user=>{:invitation_code=>inv_code, :login=>friend_email, :password=>friend_password, :password_confirmation=>friend_password}
    act_code = assigns(:user).activation_code
    assert_nil User.authenticate(friend_email, friend_password)    
    get :activate, :activation_code=>act_code
    
    assert_redirected_to edit_user_path(assigns(:current_user))
    assert_not_nil User.authenticate(friend_email, friend_password)
    assert_equal assigns(:current_user).teams.sort_by{|item| item.id}, users(:saki).teams.admin.sort_by{|item| item.id}
    assert_equal assigns(:current_user).friends, [users(:saki)]
    assert_equal 0, RegisterInvitation.count
    assert_equal 0, UnRegFriendInv.count     
    assert_equal 0, UnRegTeamInv.count    
  end

  #已邀请未注册未激活  
  def test_invite_a_invited_and_not_created_and_not_activated_user
    login_as :saki
    friend_email = "aa@bb.cc"
    friend_password = "111111"
    post :invite, :register_invitation=>{:login=>friend_email}, :teams_id=>(users(:saki).teams.admin.map{|item| item.id})
    
    initial_reg_inv_count = RegisterInvitation.count
    initial_un_reg_team_inv_count = UnRegTeamInv.count
    initial_un_reg_friend_inv_count = UnRegFriendInv.count
    
    #这里再次邀请，用新的队伍集合（只取两支队，而不是saki所管理的队伍全集）
    post :invite, :register_invitation=>{:login=>friend_email}, :teams_id=>(users(:saki).teams.admin.map{|item| item.id}[1..users(:saki).teams.admin.length-1])    
    inv_code = assigns(:register_invitation).invitation_code
    post :create_with_invitation, :user=>{:invitation_code=>inv_code, :login=>friend_email, :password=>friend_password, :password_confirmation=>friend_password}
    act_code = assigns(:user).activation_code
    assert_nil User.authenticate(friend_email, friend_password)    
    
    get :activate, :activation_code=>act_code
    
    assert_redirected_to edit_user_path(assigns(:current_user))
    assert_not_nil User.authenticate(friend_email, friend_password)
    assert_not_equal assigns(:current_user).teams.sort_by{|item| item.id}, users(:saki).teams.admin.sort_by{|item| item.id}
    assert_equal assigns(:current_user).teams.sort_by{|item| item.id}, 
                   users(:saki).teams.admin[1..users(:saki).teams.admin.length-1].sort_by{|item| item.id}    
    assert_equal assigns(:current_user).friends, [users(:saki)]
    assert_equal initial_reg_inv_count, RegisterInvitation.count
    assert_equal initial_un_reg_friend_inv_count, UnRegFriendInv.count
    assert_equal initial_un_reg_team_inv_count, UnRegTeamInv.count    
  end

  #已邀请已注册未激活  
  def test_invite_a_invited_and_created_and_not_activated_user
    login_as :saki
    friend_email = "aa@bb.cc"
    friend_password_old = "111111"
    friend_password_new = "222222"    

    post :invite, :register_invitation=>{:login=>friend_email}, :teams_id=>(users(:saki).teams.admin.map{|item| item.id})
    inv_code_old = assigns(:register_invitation).invitation_code
    post :create_with_invitation, :user=>{:invitation_code=>inv_code_old, :login=>friend_email, :password=>friend_password_old, :password_confirmation=>friend_password_old}
    assert_nil User.authenticate(friend_email, friend_password_old)   
    
    #这里再次邀请，用新的队伍集合（只取两支队，而不是saki所管理的队伍全集）
    post :invite, :register_invitation=>{:login=>friend_email}, :teams_id=>(users(:saki).teams.admin.map{|item| item.id}[1..users(:saki).teams.admin.length-1])        
    inv_code_new = assigns(:register_invitation).invitation_code
    #这里再次注册,使用了新的密码
    post :create_with_invitation, :user=>{:invitation_code=>inv_code_new, :login=>friend_email, :password=>friend_password_new, 
                                                                       :password_confirmation=>friend_password_new}    
    act_code_new = assigns(:user).activation_code
    assert_nil User.authenticate(friend_email, friend_password_new)    
    get :activate, :activation_code=>act_code_new
    
    assert_redirected_to edit_user_path(assigns(:current_user))
    assert_not_nil User.authenticate(friend_email, friend_password_new)
    #注意!!这里是由于邀请的叠加效应(第一次邀请时的队伍全集覆盖了第二次邀请的子集)
    assert_not_equal assigns(:current_user).teams.sort_by{|item| item.id}, 
                   users(:saki).teams.admin[1..users(:saki).teams.admin.length-1].sort_by{|item| item.id}        
    assert_equal assigns(:current_user).teams.sort_by{|item| item.id}, users(:saki).teams.admin.sort_by{|item| item.id}
    assert_equal assigns(:current_user).friends, [users(:saki)]
    assert_equal 0, RegisterInvitation.count
    assert_equal 0, UnRegFriendInv.count
    assert_equal 0, UnRegTeamInv.count    
  end   
  
    
  
protected
  def create_user(options = {})
    post :create, :user => { :login => 'sakinijino@gmail.com',
      :password => 'quire', :password_confirmation => 'quire' }.merge(options)
  end
  
  def create_user_with_invitation(options = {})
    post :invite, :register_invitation=>{:login=>'aa@bb.com'}
    inv_code = assigns(:register_invitation).invitation_code
    post :create_with_invitation, :user => {:invitation_code=>inv_code, :login => 'sakinijino@gmail.com',
      :password => 'quire', :password_confirmation => 'quire' }.merge(options)
  end
end
