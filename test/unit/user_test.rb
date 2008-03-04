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
    users(:quentin).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    assert_equal users(:quentin), User.authenticate('quire@example.com', 'new password')
  end

  def test_should_not_rehash_password
    users(:quentin).login = 'quire2@example.com'
    users(:quentin).save
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
  
  def test_before_validation
    users(:saki).update_attributes({:nickname => 'nickname'*50, 
        :favorite_star => 'favorite_star'*50, 
        :favorite_team => 'favorite_team'*50, 
        :summary => 'summary'*1000,
        :height => '',
        :weight => '',})
    assert users(:saki).valid?
    assert_equal 15, users(:saki).nickname.length
    assert_equal 100, users(:saki).favorite_star.length
    assert_equal 100, users(:saki).favorite_team.length
    assert_equal 3000, users(:saki).summary.length
    assert_nil users(:saki).height
    assert_nil users(:saki).weight
  end
  
  def test_set_is_playable
    assert_no_difference 'users(:saki).positions.length' do
      users(:saki).update_attributes({:premier_position=>11})
    end
    users(:saki).update_attributes({:premier_position=>0})
    assert users(:saki).positions.map {|p| p.label}.include?(0)
    users(:saki).update_attributes({:is_playable=>false, :premier_position=>nil, :height=>nil})
    assert 0, users(:saki).positions.length
    assert_nil users(:saki).height
    assert_nil users(:saki).weight
    assert_nil users(:saki).fitfoot
    assert_nil users(:saki).premier_position
    users(:saki).update_attributes({:is_playable=>true, :premier_position=>nil})
    assert users(:saki).errors.on(:premier_position)
  end
  
  def test_positions_array
    assert users(:saki).positions_array.include?(2)
    users(:saki).positions_array=[1, 0, 2, 11, 10]
    users(:saki).save
    assert_equal 5, users(:saki).positions.length
    users(:saki).positions_array=nil
    users(:saki).save
    assert_equal 1, users(:saki).positions.length #equal to 1, because premier_position
  end
  
  def test_image_path
    assert_equal "/images/users/u00000003.jpg", users(:saki).image
    assert_equal "/images/default_user.jpg", users(:aaron).image
  end
  
  def test_friends
    assert users(:saki).is_my_friend?(users(:aaron))
    assert users(:saki).is_my_friend?(users(:mike2))
    assert_equal 2, users(:saki).friends.length
  end
  
  def test_user_is_of
    assert users(:saki).is_team_member_of?(teams(:inter))
    assert !users(:aaron).is_team_member_of?(teams(:inter))
    
    assert users(:saki).is_team_admin_of?(teams(:inter))
    assert !users(:aaron).is_team_admin_of?(teams(:inter))
    assert !users(:aaron).is_team_admin_of?(teams(:milan))
  end
  
  def test_through
    assert_equal 2,  users(:saki).teams.length
    assert_equal 2, users(:saki).teams.admin.length
    assert_equal 1,  users(:quentin).teams.length
    assert_equal 1,  users(:quentin).teams.admin.length
    assert_equal 1,  users(:aaron).teams.length
    assert_equal 0,  users(:aaron).teams.admin.length
  end
  
  def test_recent_trainings
    t = users(:saki)
    assert_equal 2, t.trainings.recent(nil, DateTime.new(2008, 1, 19)).length
    assert_equal 1, t.trainings.recent(1, DateTime.new(2008, 1, 19)).length
    assert_equal 1, t.trainings.recent(nil, DateTime.new(2008, 1, 21)).length
  end
  
  def test_destroy
    assert_difference 'Position.count', -3 do
    assert_difference 'UserImage.count', -1 do
    assert_difference 'Message.count', -5 do
    assert_difference 'TrainingJoin.count', -2 do
    assert_difference 'UserTeam.count', -2 do
    assert_difference 'TeamJoinRequest.count', -2 do
    assert_difference 'Post.count', -3 do
      users(:saki).destroy
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

protected
  def create_user(options = {})
    u = User.new({:nickname=>'saki',
        :password => 'quire', :password_confirmation => 'quire' }.merge(options))
    u.login = options.key?(:login) ? options[:login]: 'sakinijino@gmail.com'
    u.save
    u
  end
end
