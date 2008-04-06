require File.dirname(__FILE__) + '/../test_helper'

class MatchInvitationsControllerTest < ActionController::TestCase

  def test_unlogin
    get :new
    assert_redirected_to new_session_path
    get :edit
    assert_redirected_to new_session_path    
    post :create
    assert_redirected_to new_session_path
    put :update
    assert_redirected_to new_session_path
    delete :destroy
    assert_redirected_to new_session_path     
  end

  def test_should_render_select_host_team
    login_as :quentin
    get :new, :guest_team_id => teams(:milan).id
    assert_template 'select_host_team'
  end

  def test_should_get_new
    login_as :quentin
    get :new, :guest_team_id => teams(:milan).id, :host_team_id => teams(:inter).id
    assert_response :success
  end

  def test_should_not_get_new
    login_as :quentin
    get :new, :guest_team_id => teams(:milan).id, :host_team_id => teams(:juven).id
    assert_redirected_to '/'
  end   

  def test_should_create_match_invitation
    login_as :quentin    
    assert_difference('MatchInvitation.count') do
      post :create, :match_invitation => {
        :host_team_id => teams(:inter).id,
        :guest_team_id => teams(:milan).id,
        :new_location => "Beijing",
        :new_start_time => 1.day.since,
        :new_half_match_length => 45,
        :new_rest_length => 15
      }
    end
    assert_equal teams(:inter).id, assigns(:match_invitation).host_team_id
    assert_equal teams(:milan).id, assigns(:match_invitation).guest_team_id    
    assert_redirected_to team_match_invitations_path(teams(:inter), :as => 'send')
  end
  
  def test_should_not_create_match_invitation
    login_as :quentin    
    assert_no_difference('MatchInvitation.count') do #host_team和guest_team是同一支队伍
      post :create, :match_invitation => {
        :host_team_id => teams(:inter).id,:guest_team_id => teams(:inter).id,
        :new_location => "Beijing",
        :new_start_time => 1.day.since,
        :new_half_match_length => 45,
        :new_rest_length => 15
      }
    end
    assert_redirected_to '/'
    assert_no_difference('MatchInvitation.count') do #current_user并不是host_team_id所对应球队的管理员
      post :create, :match_invitation => {
        :host_team_id => teams(:juven).id,
        :guest_team_id => teams(:milan).id,
        :new_location => "Beijing",
        :new_start_time => 1.day.since,
        :new_half_match_length => 45,
        :new_rest_length => 15
     }
    end
    assert_redirected_to '/'
  end
  
  
  
  def test_should_not_edit
    login_as :saki #准备数据,这里为了清晰,不使用夹具数据
    u = users(:saki)
    t1 = Team.create!(:name=>"test1",:shortname=>"t1")
    t2 = Team.create!(:name=>"test2",:shortname=>"t2")
    ut = UserTeam.new
    ut.user_id = u.id
    ut.team_id = t1.id   
    inv1 = create_match_invitation   
    inv1.host_team_id = t1.id
    inv1.guest_team_id = t2.id     
    
    ut.is_admin = true #如果当前saki并不是t1队的管理员
    ut.save!
    inv1.edit_by_host_team = true #如果当前是主队（主队也就是t1队）在编辑
    inv1.save!
    
    get :edit, :id => inv1.id
    assert_response :success
  end
  
  def test_should_not_edit
    login_as :saki #准备数据,这里为了清晰,不使用夹具数据
    u = users(:saki)
    t1 = Team.create!(:name=>"test1",:shortname=>"t1")
    t2 = Team.create!(:name=>"test2",:shortname=>"t2")
    ut = UserTeam.new
    ut.user_id = u.id
    ut.team_id = t1.id   
    inv1 = create_match_invitation   
    inv1.host_team_id = t1.id
    inv1.guest_team_id = t2.id    
    
    ut.is_admin = false #如果当前saki并不是t1队的管理员
    ut.save!
    inv1.edit_by_host_team = true #如果当前是主队（主队也就是t1队）在编辑
    inv1.save!    
    get :edit, :id => inv1.id
    assert_redirected_to '/'

    inv1.edit_by_host_team = false #如果当前并不是主队（主队也就是t1队）在编辑
    inv1.save!    
    get :edit, :id => inv1.id
    assert_redirected_to '/'    
  end    

  
  
  def test_should_not_update
    login_as :saki #准备数据,这里为了清晰,不使用夹具数据
    u = users(:saki)
    t1 = Team.create!(:name=>"test1",:shortname=>"t1")
    t2 = Team.create!(:name=>"test2",:shortname=>"t2")
    ut = UserTeam.new
    ut.user_id = u.id
    ut.team_id = t1.id   
    inv1 = create_match_invitation   
    inv1.host_team_id = t1.id
    inv1.guest_team_id = t2.id
    
    ut.is_admin = false #如果当前saki并不是t1队的管理员
    ut.save!
    inv1.edit_by_host_team = true #如果当前是主队（主队也就是t1队）在编辑
    inv1.save!    
    put :update, :id => inv1.id, :match_invitation => {}
    assert_redirected_to '/'
    
    ut.is_admin = true #将saki复位为t1队的管理员
    ut.save!    
    inv1.edit_by_host_team = false #如果当前并不是主队（主队也就是t1队）在编辑
    inv1.save!    
    put :update, :id => inv1.id, :match_invitation => {}
    assert_redirected_to '/'       
  end

  
  def test_should_update_by_host_team
    login_as :saki #准备数据,这里为了清晰,不使用夹具数据
    u = users(:saki)
    t1 = Team.create!(:name=>"test1",:shortname=>"t1")
    t2 = Team.create!(:name=>"test2",:shortname=>"t2")
    ut = UserTeam.new
    ut.user_id = u.id
    ut.team_id = t1.id   
    inv1 = create_match_invitation   
    inv1.host_team_id = t1.id
    inv1.guest_team_id = t2.id    
    
    ut.is_admin = true #准备权限,此时saki是当前具有编辑权限的主队的管理员
    ut.save!    
    inv1.edit_by_host_team = true
    
    inv1.new_description = "test_description"
    inv1.save!
    
    assert_equal "test_description", inv1.new_description
    assert_equal nil, inv1.description
    assert_equal "", inv1.host_team_message
    assert_equal "", inv1.guest_team_message   
    put :update, :id => inv1.id, :match_invitation => {:host_team_message => "test",
                                                       :guest_team_message => "test",
                                                       :new_description => "test_description_2",
                                                       :description => "test_description_2"
                                                       }
    new_inv1 = MatchInvitation.find(inv1.id)
    assert_equal "test_description_2", new_inv1.new_description #测试普通属性的更新是否成功
    assert_equal "test_description", new_inv1.description #测试save_last_info!是否成功
    assert_equal "test", new_inv1.host_team_message #测试只能修改当前具有编辑权限的球队所对应的留言
    assert_equal "", new_inv1.guest_team_message
    assert_redirected_to team_match_invitations_path(t1, :as => 'send')
  end
  
  def test_should_update_by_guest_team #这个测试与上面的test_should_update_by_host_team对应，用来保证全路径覆盖
    login_as :saki #准备数据,这里为了清晰,不使用夹具数据
    u = users(:saki)
    t1 = Team.create!(:name=>"test1",:shortname=>"t1")
    t2 = Team.create!(:name=>"test2",:shortname=>"t2")
    ut = UserTeam.new
    ut.user_id = u.id
    ut.team_id = t2.id #现在saki的球队变成了t2   
    inv1 = create_match_invitation   
    inv1.host_team_id = t1.id
    inv1.guest_team_id = t2.id #现在saki的t2成为了客队    
    
    ut.is_admin = true #准备权限,此时saki是当前具有编辑权限的客队的管理员
    ut.save!    
    inv1.edit_by_host_team = false
    
    inv1.new_description = "test_description"    
    inv1.save!
    
    assert_equal "test_description", inv1.new_description
    assert_equal nil, inv1.description
    assert_equal "", inv1.host_team_message
    assert_equal "", inv1.guest_team_message    
    put :update, :id => inv1.id, :match_invitation => {:host_team_message=>"test",
                                                       :guest_team_message=>"test",
                                                       :new_description=>"test_description_2",
                                                       :description => "test_description_2"
                                                       }
    new_inv1 = MatchInvitation.find(inv1.id)
    assert_equal "test_description_2", new_inv1.new_description #测试普通属性的更新是否成功
    assert_equal "test_description", new_inv1.description #测试save_last_info!是否成功
    assert_equal "", new_inv1.host_team_message #测试只能修改当前具有编辑权限的球队所对应的留言
    assert_equal "test", new_inv1.guest_team_message
    assert_redirected_to team_match_invitations_path(t2, :as => 'send')
  end  
  
  
  def test_should_destroy_match_invitation
    MatchInvitation.destroy_all
    login_as :saki
    u = users(:saki)
    t1 = Team.create!(:name=>"test1",:shortname=>"t1")
    t2 = Team.create!(:name=>"test2",:shortname=>"t2")
    ut = UserTeam.new
    ut.user_id = u.id
    ut.team_id = t1.id
    ut.is_admin = true
    ut.save     
    inv1 = create_match_invitation   
    inv1.host_team_id = t1.id
    inv1.guest_team_id = t2.id    
    inv1.edit_by_host_team = true #如果当前是主队在编辑
    inv1.save!
    assert_difference('MatchInvitation.count', -1) do
      delete :destroy, :id => inv1.id
    end
    assert_redirected_to team_match_invitations_path(t1)
    
    inv2 = create_match_invitation
    inv2.host_team_id = t2.id #saki现在成了客队的管理员
    inv2.guest_team_id = t1.id    
    inv2.edit_by_host_team = false #如果当前是客队在编辑
    inv2.save!     
    assert_difference('MatchInvitation.count', -1) do
      delete :destroy, :id => inv2.id
    end
    assert_redirected_to team_match_invitations_path(t1)
  end


  
  def test_should_not_destroy_match_invitation
    MatchInvitation.destroy_all
    login_as :saki
    u = users(:saki)
    t1 = Team.create!(:name=>"test1",:shortname=>"t1")
    t2 = Team.create!(:name=>"test2",:shortname=>"t2")
    ut = UserTeam.new
    ut.user_id = u.id
    ut.team_id = t1.id
    
    ut.is_admin = false #如果saki当前并不是管理员身份
    ut.save     
    inv1 = create_match_invitation   
    inv1.host_team_id = t1.id
    inv1.guest_team_id = t2.id    
    inv1.edit_by_host_team = true #如果当前是主队在编辑
    inv1.save!
    assert_no_difference 'MatchInvitation.count' do
      delete :destroy, :id => inv1.id
    end
    assert_redirected_to '/'

    ut.is_admin = true #如果saki当前是管理员身份
    ut.save     
    inv1 = create_match_invitation
    inv1.host_team_id = t1.id
    inv1.guest_team_id = t2.id    
    inv1.edit_by_host_team = false #如果当前并不是主队在编辑
    inv1.save!
    assert_no_difference 'MatchInvitation.count' do
      delete :destroy, :id => inv1.id
    end
    assert_redirected_to '/'
  end
protected
  def create_match_invitation
    m = MatchInvitation.new
    m.new_location = "Beijing"
    m.new_start_time = 1.day.since
    m.new_half_match_length = 45
    m.new_rest_length = 15
    m
  end
end
