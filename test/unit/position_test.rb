require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead.
  # Then, you can remove it from this and the functional test.
  include AuthenticatedTestHelper
  fixtures :users
  fixtures :positions
  
  def test_new_position
    assert_difference 'Position.count' do
      saki = users(:saki)
      saki.positions<< Position.new({:label=> 10})
      saki.save
    end
    
    assert_no_difference 'Position.count' do
      saki = users(:saki)
      saki.positions<< Position.new({:label=> 123})
      saki.save
    end
  end
  
  def test_destroy
    assert_difference 'Position.count', -3 do
      saki = users(:saki)
      saki.destroy
    end
  end
end