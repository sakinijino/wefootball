require File.dirname(__FILE__) + '/../test_helper'

class MessageTest < ActiveSupport::TestCase
  def test_can_read_by
    m1 = messages(:saki_mike1)
    assert m1.can_read_by(users(:saki))
    assert m1.can_read_by(users(:mike1).id)
    m1 = messages(:saki_mike1_2)
    assert !m1.can_read_by(users(:saki))
    m1 = messages(:saki_mike1_3)
    assert !m1.can_read_by(users(:mike1).id)
  end
end
