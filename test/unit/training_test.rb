require File.dirname(__FILE__) + '/../test_helper'

class TrainingTest < ActiveSupport::TestCase
  # Replace this with your real tests.
#  def test_truth
#    assert true
#  end
  def test_create
    t = Training.create({})
    assert_not_nil t.id
    assert_not_nil t.start_time
    assert_not_nil t.end_time
    assert_not_nil t.location
    assert_not_nil t.summary
  end
end
