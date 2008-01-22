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
  
  def test_can_join
    assert trainings(:training1).already_join?(users(:saki))
    assert !trainings(:training1).already_join?(users(:quentin))
    assert trainings(:training1).can_join?(users(:quentin))
    assert !trainings(:training1).can_join?(users(:saki))
    assert !trainings(:training1).can_join?(users(:mike1))
  end
end
