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
  end
  
  def test_can_join
    assert trainings(:training1).has_member?(users(:saki))
    assert !trainings(:training1).has_member?(users(:quentin))
    assert trainings(:training1).can_be_joined_by?(users(:quentin))
    assert !trainings(:training1).can_be_joined_by?(users(:saki))
    assert !trainings(:training1).can_be_joined_by?(users(:mike1))
  end
  
  def test_summary_length
    t = trainings(:training1)
    t.update_attributes({:summary=>'s'*2000})
    assert_equal 1000, t.summary.length
  end
  
  def test_public_posts
    t = Training.find(1)
    assert_equal 3, t.posts.length
    assert_equal 2, t.posts.public.length
  end
  
  def test_no_accessible
    t = trainings(:training1)
    tid = t.team_id
    t.update_attributes(:team_id=>2, :location=>'Shanghai')
    assert_equal tid, t.team_id
    assert_equal 'Shanghai', t.location
  end
  
  def test_destroy
    assert_difference 'TrainingJoin.count', -1 do
    assert_difference 'Post.count', -3 do
      trainings(:training1).destroy
    end
    end
  end
end
