require File.dirname(__FILE__) + '/../test_helper'

class WatchTest < ActiveSupport::TestCase
  
  def test_cascade_destroy_from_official_match_to_watch
    assert_equal 2, official_matches(:one).watches.size
    assert_difference('Watch.count', -2) do
      official_matches(:one).destroy
    end
  end

  def test_cascade_destroy_from_watch_to_watch_join 
    assert_equal 3, watches(:one).watch_joins.size
    assert_difference('WatchJoin.count', -3) do
      watches(:one).destroy
    end
  end 
end
