require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead.
  # Then, you can remove it from this and the functional test.
  include AuthenticatedTestHelper
  fixtures :users
  fixtures :positions
  
  def test_positions
    saki = users(:saki)
    ps = saki.positions.map {|p| p.label}
    assert ps.include?('CB')
    assert ps.include?('SS')
    assert ps.include?('DM')
    assert !ps.include?('LB')
  end
  
  def test_new_position
    assert_difference 'Position.count' do
      saki = users(:saki)
      saki.positions<< Position.new({:label=> 'CF'})
      saki.save
    end
    
    assert_no_difference 'Position.count' do
      saki = users(:saki)
      saki.positions<< Position.new({:label=> '123'})
      saki.save
    end
  end
  
  def test_destroy
    u = create_user
    assert_no_difference 'Position.count' do
      u.positions<<Position.new({:label=> 'CF'})
      u.destroy
    end
  end
  
protected
  def create_user(options = {})
    User.create({ :login => 'mike@gmail.com', 
        :password => 'quire', :password_confirmation => 'quire' }.merge(options))
  end
end