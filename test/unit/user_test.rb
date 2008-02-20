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
  
  def test_should_require_nickname
    assert_no_difference 'User.count' do
      u = create_user(:nickname => nil)
      assert u.errors.on(:nickname)
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
    users(:quentin).update_attributes(:login => 'quire2@example.com')
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
  
  def test_validation
    assert_no_difference 'User.count' do
      u = create_user({:login=>'saki@usertest.com',
          :fitfoot=>'X'
        })
      assert u.errors.on(:fitfoot)
    end
    
    assert_no_difference 'User.count' do
      u = create_user({:login=>'saki@usertest.com',
          :weight=>1000
        })
      assert u.errors.on(:weight)
    end
    
    assert_no_difference 'User.count' do
      u = create_user({:login=>'saki@usertest.com',
          :height=>400
        })

      assert u.errors.on(:height)
    end
    
    assert_no_difference 'User.count' do
      u = create_user({:login=>'saki@usertest.com',
          :nickname=>'s'*100
        })
      assert u.errors.on(:nickname)
    end
    
    assert_no_difference 'User.count' do
      u = create_user({:login=>'saki@usertest.com',
          :summary=>'s'*1000
        })
      assert u.errors.on(:summary)
    end
  end
  
  def test_image_path
    assert_equal "/images/users/u00000003.jpg", users(:saki).image
    assert_equal "/images/default_user.jpg", users(:aaron).image
  end

protected
  def create_user(options = {})
    User.create({ :login => 'sakinijino@gmail.com', :nickname=>'saki',
        :password => 'quire', :password_confirmation => 'quire' }.merge(options))
  end
end
