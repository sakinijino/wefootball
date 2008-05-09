require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead.
  # Then, you can remove it from this and the functional test.
  include AuthenticatedTestHelper
  fixtures :users

  def test_should_create_user
    assert_difference 'User.count' do
      user = create_user
      assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
    end
  end

  def test_should_require_login
    assert_no_difference 'User.count' do
      u = create_user(:login => nil)
      assert u.errors.on(:login)
    end
  end
  
  def test_default_nickname
    assert_difference 'User.count' do
      u = create_user(:nickname => nil)
      assert 'sakinijino', u.nickname
    end
  end
  
  def test_login_should_be_email
    assert_no_difference 'User.count' do
      u = create_user(:login => 'saki')
      assert u.errors.on(:login)
    end
  end

  def test_should_require_password
    assert_no_difference 'User.count' do
      u = create_user(:password => nil)
      assert u.errors.on(:password)
    end
  end

  def test_should_require_password_confirmation
    assert_no_difference 'User.count' do
      u = create_user(:password_confirmation => nil)
      assert u.errors.on(:password_confirmation)
    end
  end

  def test_should_reset_password
    users(:quentin).update_attributes!(:password => 'new password', :password_confirmation => 'new password')
    assert_equal users(:quentin), User.authenticate('quire@example.com', 'new password')
  end

  def test_should_not_rehash_password
    users(:quentin).login = 'quire2@example.com'
    users(:quentin).save!
    assert_equal users(:quentin), User.authenticate('quire2@example.com', 'test')
  end

  def test_should_authenticate_user
    assert_equal users(:quentin), User.authenticate('quire@example.com', 'test')
  end

  def test_should_set_remember_token
    users(:quentin).remember_me
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
  end

  def test_should_unset_remember_token
    users(:quentin).remember_me
    assert_not_nil users(:quentin).remember_token
    users(:quentin).forget_me
    assert_nil users(:quentin).remember_token
  end

  def test_should_remember_me_for_one_week
    before = 1.week.from_now.utc
    users(:quentin).remember_me_for 1.week
    after = 1.week.from_now.utc
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
    assert users(:quentin).remember_token_expires_at.between?(before, after)
  end

  def test_should_remember_me_until_one_week
    time = 1.week.from_now.utc
    users(:quentin).remember_me_until time
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
    assert_equal users(:quentin).remember_token_expires_at, time
  end

  def test_should_remember_me_default_two_weeks
    before = 2.weeks.from_now.utc
    users(:quentin).remember_me
    after = 2.weeks.from_now.utc
    assert_not_nil users(:quentin).remember_token
    assert_not_nil users(:quentin).remember_token_expires_at
    assert users(:quentin).remember_token_expires_at.between?(before, after)
  end
  
  def test_blog_validation
    u = users(:saki)
    u.blog = "sakinijino.blogbus.com"
    assert u.valid?
    u.blog = "www.google.com/search?hl=en&q=ruby+url+regexp"
    assert u.valid?
    u.blog = "http://sakinijino.blogbus.com"
    assert !u.valid?
    assert_not_nil u.errors.on(:full_blog_uri)
    u.blog = "sakinijino.blogbus.com'>sakinijino.blogbus.com</a><script></script>"
    assert !u.valid?
    assert_not_nil u.errors.on(:full_blog_uri)   
  end
  
  def test_before_validation
    users(:saki).update_attributes!({:nickname => 'nickname'*50, 
        :favorite_star => 'favorite_star'*50, 
        :favorite_team => 'favorite_team'*50, 
        :summary => 'summary'*1000,
        :height => '',
        :weight => '',})
    assert users(:saki).valid?
    assert_equal 15, users(:saki).nickname.length
    assert_equal 200, users(:saki).favorite_star.length
    assert_equal 200, users(:saki).favorite_team.length
    assert_equal 3000, users(:saki).summary.length
    assert_nil users(:saki).height
    assert_nil users(:saki).weight
  end
  
  def test_set_is_playable
    assert_no_difference 'users(:saki).positions.length' do
      users(:saki).update_attributes!({:premier_position=>11})
    end
    users(:saki).update_attributes!({:premier_position=>0})
    assert users(:saki).positions.map {|p| p.label}.include?(0)
    users(:saki).update_attributes!({:is_playable=>false, :premier_position=>nil, :height=>nil})
    assert_equal 0, users(:saki).positions.length
    assert_nil users(:saki).height
    assert_nil users(:saki).weight
    assert_nil users(:saki).fitfoot
    assert_nil users(:saki).premier_position
    assert_equal 0, UserTeam.find(:all, :conditions => ["user_id = ? and is_player = ?", users(:saki).id, true]).length
    assert_equal 0, UserTeam.find(:all, :conditions => ["user_id = ? and position is not null", users(:saki).id]).length
    users(:saki).update_attributes({:is_playable=>true, :premier_position=>nil})
    assert users(:saki).errors.on(:premier_position)
  end
  
  def test_positions_array
    assert users(:saki).positions_array.include?(2)
    users(:saki).positions_array=[1, 0, 2, 11, 10]
    users(:saki).save!
    assert_equal 5, users(:saki).positions.length
    users(:saki).positions_array=nil
    users(:saki).save!
    assert_equal 1, users(:saki).positions.length #equal to 1, because premier_position
  end
  
  def test_city_text
    u = users(:saki)
    u.city = 0
    assert_nil u.city_text
    u.city = 1
    assert_equal ProvinceCity::LIST[1], u.city_text
  end
  
  def test_gender_text
    u = User.new
    u.gender = 0
    assert_equal '他', u.gender_text
    u.gender = 1
    assert_equal '他', u.gender_text
    u.gender = 2
    assert_equal '她', u.gender_text
  end
  
  def test_birthday_type
    u = users(:saki)
    u.birthday_display_type = 0
    assert_nil u.birthday_text
    assert_nil u.age
    u.birthday_display_type = 1
    assert_equal u.birthday.strftime("%Y年%m月%d日"), u.birthday_text
    assert_equal Date.today.year - u.birthday.year, u.age
    u.birthday_display_type = 2
    assert_equal u.birthday.strftime("%m月%d日"), u.birthday_text
    assert_nil u.age
    u.birthday_display_type = 3
    assert_equal u.birthday.strftime("%Y年"), u.birthday_text
    assert_equal Date.today.year - u.birthday.year, u.age
  end
  
  def test_image_path
    assert_equal User::DEFAULT_IMAGE, users(:saki).image
    assert_equal User::DEFAULT_IMAGE, users(:aaron).image
    assert_equal "/images/users/00/00/00/03.not_image", users(:saki).image(nil, :refresh)
    assert_equal User::DEFAULT_IMAGE, users(:aaron).image(nil, :refresh)
    assert_equal "/images/users/00/00/00/03.not_image", users(:saki).image
    assert_equal User::DEFAULT_IMAGE, users(:aaron).image
  end
  
  def test_friends
    assert users(:saki).is_my_friend?(users(:aaron))
    assert users(:saki).is_my_friend?(users(:mike2))
    assert_equal 2, users(:saki).friends.length
    assert_equal 2, users(:saki).friend_ids.length
  end
  
  def test_user_is_of
    assert users(:saki).is_team_member_of?(teams(:inter))
    assert !users(:aaron).is_team_member_of?(teams(:inter))
    
    assert users(:saki).is_team_admin_of?(teams(:inter))
    assert !users(:aaron).is_team_admin_of?(teams(:inter))
    assert !users(:aaron).is_team_admin_of?(teams(:milan))
  end
  
  def test_through
    assert_equal 3,  users(:saki).teams.length
    assert_equal 2, users(:saki).teams.admin.length
    assert_equal 1,  users(:quentin).teams.length
    assert_equal 1,  users(:quentin).teams.admin.length
    assert_equal 1,  users(:aaron).teams.length
    assert_equal 0,  users(:aaron).teams.admin.length
  end
  
  def test_recent_trainings
    t = users(:saki)
    assert_equal 4, t.trainings.recent(nil, DateTime.new(2008, 1, 19)).length
    assert_equal 1, t.trainings.recent(1, DateTime.new(2008, 1, 19)).length
    assert_equal 3, t.trainings.recent(nil, DateTime.new(2008, 1, 21)).length
  end
  
  def test_destroy
    p = PlayJoin.new
    p.user = users(:saki)
    p.play_id = 1
    p.save!
    m = MatchJoin.new
    m.user = users(:saki)
    m.team_id = 1
    m.match_id = 1
    m.save!
    s = SidedMatchJoin.new
    s.user = users(:saki)
    s.match_id = 1
    s.save!
    
    assert_difference 'Position.count', -(Position.count(:conditions => ['user_id = ?', users(:saki)])) do
    assert_difference 'UserImage.count', -(UserImage.find_all_by_user_id(users(:saki)).size) do
    assert_difference 'Message.count', -(Message.count(:conditions => ['sender_id = ? or receiver_id = ?', users(:saki), users(:saki)])) do
    assert_difference 'TrainingJoin.count', -(TrainingJoin.find_all_by_user_id(users(:saki)).size) do
    assert_difference 'PlayJoin.count', -(PlayJoin.find_all_by_user_id(users(:saki)).size) do
    assert_difference 'MatchJoin.count', -(MatchJoin.find_all_by_user_id(users(:saki)).size) do
    assert_difference 'SidedMatchJoin.count', -(SidedMatchJoin.find_all_by_user_id(users(:saki)).size) do
    assert_difference 'UserTeam.count', -(UserTeam.find_all_by_user_id(users(:saki)).size) do
    assert_difference 'TeamJoinRequest.count', -(TeamJoinRequest.find_all_by_user_id(users(:saki)).size) do
    assert_difference 'Post.count', -(Post.find_all_by_user_id(users(:saki)).size) do
    assert_difference 'SitePost.count', -(SitePost.find_all_by_user_id(users(:saki)).size) do
      users(:saki).destroy
    end
    end
    end
    end
    end
    end
    end
    end
    end
    end
    end
  end
  
  def test_search
    create_user({:login => 'sakinijinoo@gmail.com', :nickname=>'AiHaibara'})
    create_user({:login => 'sakinijinoo0725@gmail.com', :nickname=>'NagatoYuki'})
    users = User.find_by_contents("AiHaibara")
    assert 1, users.length
    users = User.find_by_contents("gmail")
    assert 2, users.length
  end
  
  def test_can_invite_team
    u = create_user({:login => 'sakinijinoo@gmail.com', :nickname=>'AiHaibara'})
    t1 = Team.create!(:name=>"test1",:shortname=>"t1")
    t2 = Team.create!(:name=>"test2",:shortname=>"t2")
    
    ut1 = UserTeam.new
    ut1.user_id = u.id
    ut1.team_id = t1.id
    ut1.is_admin = false #如果不是管理员则肯定不能发起约战邀请
    ut1.save    
    assert_equal false, u.can_invite_team?(t1)    
    assert_equal false, u.can_invite_team?(t2)

    ut1.is_admin = true#如果是管理员
    ut1.save    
    assert_equal false, u.can_invite_team?(t1)#不能邀请自己所管理的唯一球队
    assert_equal true, u.can_invite_team?(t2)

    t3 = Team.create!(:name=>"test3",:shortname=>"t3")
    ut3 = UserTeam.new
    ut3.user_id = u.id
    ut3.team_id = t3.id
    ut3.is_admin = true #在管理了一支以上球队的情况下
    ut3.save
    assert_equal true, u.can_invite_team?(t1)#可以邀请自己所管理多支球队中的一支
  end
  
  def test_can_act_on_match_invitation #测试can_edit_match_invitation、can_reject_match_invitation和can_accept_match_invitation
    u = create_user({:login => 'sakinijinoo@gmail.com', :nickname=>'AiHaibara'})
    u2 = create_user({:login => 'sakinijinoo123@gmail.com', :nickname=>'AiHaibara'})
    t1 = Team.create!(:name=>"test1",:shortname=>"t1")
    t2 = Team.create!(:name=>"test2",:shortname=>"t2")
    inv = MatchInvitation.new
    inv.host_team_id = t1.id
    inv.guest_team_id = t2.id
    inv.new_location = "Beijing"
    inv.new_start_time = 1.day.since
    inv.new_half_match_length = 45
    inv.new_rest_length = 15
    inv.edit_by_host_team = true #如果当前是主队在编辑
    inv.save!
    ut = UserTeam.new
    ut.user_id = u.id
    ut.team_id = t1.id
    ut.is_admin = true
    ut.save!
    ut2 = UserTeam.new
    ut2.user_id = u2.id
    ut2.team_id = t1.id
    ut2.is_admin = true
    ut2.save!
    assert_equal true, u.can_edit_match_invitation?(inv)  
    assert_equal true, u.can_accpet_match_invitation?(inv)
    assert_equal true, u.can_reject_match_invitation?(inv)
    ut.is_admin = false #而且用户是主队的管理员
    ut.save!
    assert_equal false, u.can_edit_match_invitation?(inv)  
    assert_equal false, u.can_accpet_match_invitation?(inv)
    assert_equal false, u.can_reject_match_invitation?(inv)

    inv.edit_by_host_team = false #如果当前是客队在编辑
    inv.save!
    ut.is_admin = true 
    ut.save!    
    assert_equal false, u.can_edit_match_invitation?(inv)  
    assert_equal false, u.can_accpet_match_invitation?(inv)
    assert_equal false, u.can_reject_match_invitation?(inv)
    ut.is_admin = false
    ut.save!
    assert_equal false, u.can_edit_match_invitation?(inv)  
    assert_equal false, u.can_accpet_match_invitation?(inv)
    assert_equal false, u.can_reject_match_invitation?(inv)        
  end
  
  def test_can_not_accept_outdated_match_invitation
    u = create_user({:login => 'sakinijinoo@gmail.com', :nickname=>'AiHaibara'})
    t1 = Team.create!(:name=>"test1",:shortname=>"t1")
    t2 = Team.create!(:name=>"test2",:shortname=>"t2")
    inv = MatchInvitation.new
    inv.host_team_id = t1.id
    inv.guest_team_id = t2.id
    inv.new_location = "Beijing"
    inv.new_start_time = 1.day.ago
    inv.new_half_match_length = 45
    inv.new_rest_length = 15
    inv.edit_by_host_team = true #如果当前是主队在编辑
    inv.save_without_validation!
    ut = UserTeam.new
    ut.user_id = u.id
    ut.team_id = t1.id
    ut.is_admin = true
    ut.save!
    assert !u.can_accpet_match_invitation?(inv) #过期邀请不能接收
  end
  
  def test_recent_match #测试user.matches.recent
    u = create_user({:login => 'sakinijinoo@gmail.com', :nickname=>'AiHaibara'})
    t1 = Team.create!(:name=>"test1",:shortname=>"t1")
    t2 = Team.create!(:name=>"test2",:shortname=>"t2")
    ut = UserTeam.new
    ut.user_id = u.id
    ut.team_id = t1.id
    ut.save!
    
    m1 = Match.new
    m1.host_team_id = t1.id
    m1.guest_team_id = t2.id
    m1.start_time = 7.days.ago
    m1.location = 'Building 26'
    m1.save!
    m2 = Match.new
    m2.host_team_id = t2.id
    m2.guest_team_id = t1.id
    m2.start_time = 7.days.since
    m2.location = 'Building 45A'
    m2.save!
    
    MatchJoin.create_joins(m1)
    MatchJoin.create_joins(m2)
    
    assert_equal [m1,m2],u.matches.sort_by{|i| i.start_time}
    assert_equal [m2],u.matches.recent        
  end  

protected
  def create_user(options = {})
    u = User.new({:nickname=>'saki',
        :password => 'quire', :password_confirmation => 'quire' }.merge(options))
    u.login = options.key?(:login) ? options[:login]: 'sakinijino@gmail.com'
    u.save
    u
  end
end
