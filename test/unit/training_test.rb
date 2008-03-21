require File.dirname(__FILE__) + '/../test_helper'

class TrainingTest < ActiveSupport::TestCase
  # Replace this with your real tests.
#  def test_truth
#    assert true
#  end
  def test_create
    t = Training.create!({:football_ground_id=>football_grounds(:yiti).id})
    assert_not_nil t.id
    assert_not_nil t.start_time
    assert_not_nil t.end_time
    assert_not_nil t.location
    assert_equal football_grounds(:yiti).name, t.location
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
    t.update_attributes!({:summary=>'s'*2000, :start_time => Time.now.since(3600), :end_time => Time.now.since(7200)})
    assert_equal 1000, t.summary.length
  end
  
  def test_validate_time
    t = Training.new(:start_time => Time.now.ago(7200), :end_time => Time.now.since(7200), :location => 'Beijing')
    assert !t.valid?
    assert t.errors.on(:start_time)
    t = Training.new(:start_time => Time.now.since(3600), :end_time => Time.now.since(60), :location => 'Beijing')
    assert !t.valid?
    assert t.errors.on(:end_time)
    t = Training.new(:start_time => Time.now.since(3600), :end_time => Time.now.since(3660), :location => 'Beijing')
    assert !t.valid?
    assert t.errors.on(:end_time)
    t = Training.new(:start_time => Time.now.since(3600), :end_time => Time.now.tomorrow.since(3660), :location => 'Beijing')
    assert !t.valid?
    assert t.errors.on(:end_time)
  end
  
  def test_public_posts
    t = Training.find(1)
    assert_equal 3, t.posts.length
    assert_equal 2, t.posts.public.length
  end
  
  def test_no_accessible
    t = trainings(:training1)
    tid = t.team_id
    t.update_attributes!(:team_id=>2, :location=>'Shanghai', :start_time => Time.now.since(3600), :end_time => Time.now.since(7200))
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
