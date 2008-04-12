require File.dirname(__FILE__) + '/../test_helper'

class TrainingTest < ActiveSupport::TestCase

  def test_create
    assert_difference('TrainingJoin.count', teams(:inter).users.size) do
      t = Training.new({:football_ground_id=>football_grounds(:yiti).id})
      t.team = teams(:inter)
      t.save!
      assert_not_nil t.id
      assert_not_nil t.start_time
      assert_not_nil t.end_time
      assert_equal football_grounds(:yiti).name, t.location
      assert_equal teams(:inter).users.size, t.users.undetermined.size
      assert_equal 0, t.users.joined.size
    end
  end
  
  def test_time_check
    trainings(:training1).start_time = Time.now.tomorrow
    trainings(:training1).end_time = Time.now.tomorrow.since(3600)
    trainings(:training1).save!
    assert !trainings(:training1).started?
    assert !trainings(:training1).finished?
    assert !trainings(:training1).finished_before_3_days?
    
    trainings(:training1).start_time = Time.now.ago(1800)
    trainings(:training1).end_time = Time.now.since(3600)
    trainings(:training1).save_without_validation!
    assert trainings(:training1).started?
    assert !trainings(:training1).finished?
    assert !trainings(:training1).finished_before_3_days?
    
    trainings(:training1).start_time = 1.days.ago
    trainings(:training1).end_time = 1.days.ago.since(3600)
    trainings(:training1).save_without_validation!
    assert trainings(:training1).started?
    assert trainings(:training1).finished?
    assert !trainings(:training1).finished_before_3_days?
    
    trainings(:training1).start_time = 4.days.ago
    trainings(:training1).end_time = 4.days.ago.since(3600)
    trainings(:training1).save_without_validation!
    assert trainings(:training1).started?
    assert trainings(:training1).finished?
    assert trainings(:training1).finished_before_3_days?
  end
  
  def test_can_join
    trainings(:training1).start_time = Time.now.tomorrow
    trainings(:training1).end_time = Time.now.tomorrow.since(3600)
    trainings(:training1).save!
    assert trainings(:training1).has_member?(users(:saki)) #已加入
    assert !trainings(:training1).has_member?(users(:quentin)) #未加入
    
    assert trainings(:training1).can_be_joined_by?(users(:quentin)) #可以加入
    assert !trainings(:training1).can_be_joined_by?(users(:saki)) #已加入，不能再加入
    assert !trainings(:training1).can_be_joined_by?(users(:mike1)) #不是本队，不能加入
    
    assert !trainings(:training1).can_be_quited_by?(users(:quentin)) #未加入，不能退出
    assert trainings(:training1).can_be_quited_by?(users(:saki)) #可以退出
    assert !trainings(:training1).can_be_quited_by?(users(:mike1)) #不能退出
    
    trainings(:training1).start_time = 1.days.ago
    trainings(:training1).end_time = 1.days.ago.since(3600)
    trainings(:training1).save_without_validation!
    
    assert !trainings(:training1).can_be_joined_by?(users(:quentin)) #已经结束不能加入
    assert !trainings(:training1).can_be_quited_by?(users(:saki)) #已经结束，不能退出
 
    
    trainings(:training1).start_time = 4.days.ago
    trainings(:training1).end_time = 4.days.ago.since(3600)
    trainings(:training1).save_without_validation!
    
    assert !trainings(:training1).can_be_joined_by?(users(:quentin)) #结束3天不能加入
    assert !trainings(:training1).can_be_quited_by?(users(:saki)) #已经结束，不能退出
  end
  
  def test_training_join_status
    trainings(:training1).start_time = Time.now.tomorrow
    trainings(:training1).end_time = Time.now.tomorrow.since(3600)
    trainings(:training1).save!
    
    tj = TrainingJoin.new
    tj.user = users(:quentin)
    tj.training = trainings(:training1)
    tj.status = TrainingJoin::UNDETERMINED
    tj.save!
    
    assert trainings(:training1).has_member?(users(:quentin)) #待定
    assert !trainings(:training1).has_joined_member?(users(:quentin)) #待定
    
    assert trainings(:training1).can_be_joined_by?(users(:quentin))
    assert trainings(:training1).can_be_quited_by?(users(:quentin))
  end
  
  def test_can_edit_or_destroy
    trainings(:training1).start_time = Time.now.tomorrow
    trainings(:training1).end_time = Time.now.tomorrow.since(3600)
    trainings(:training1).save!
    assert trainings(:training1).can_be_modified_by?(users(:saki))
    assert trainings(:training1).can_be_destroyed_by?(users(:saki))
    assert !trainings(:training1).can_be_modified_by?(users(:mike1))
    assert !trainings(:training1).can_be_destroyed_by?(users(:mike1))
    
    trainings(:training1).start_time = Time.now.ago(1800)
    trainings(:training1).end_time = Time.now.since(3600)
    trainings(:training1).save_without_validation!
    assert !trainings(:training1).can_be_modified_by?(users(:saki))
    assert trainings(:training1).can_be_destroyed_by?(users(:saki))
    assert !trainings(:training1).can_be_modified_by?(users(:mike1))
    assert !trainings(:training1).can_be_destroyed_by?(users(:mike1))
    
    trainings(:training1).start_time = 2.days.ago
    trainings(:training1).end_time = 2.days.ago.since(3600)
    trainings(:training1).save_without_validation!
    assert !trainings(:training1).can_be_modified_by?(users(:saki))
    assert trainings(:training1).can_be_destroyed_by?(users(:saki))
    assert !trainings(:training1).can_be_modified_by?(users(:mike1))
    assert !trainings(:training1).can_be_destroyed_by?(users(:mike1))
    
    trainings(:training1).start_time = 5.days.ago
    trainings(:training1).end_time = 5.days.ago.since(3600)
    trainings(:training1).save_without_validation!
    assert !trainings(:training1).can_be_modified_by?(users(:saki))
    assert !trainings(:training1).can_be_destroyed_by?(users(:saki))
    assert !trainings(:training1).can_be_modified_by?(users(:mike1))
    assert !trainings(:training1).can_be_destroyed_by?(users(:mike1))
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
    assert_equal 1, t.posts.public(:limit=>1).length
  end
  
  def test_posts_dependency_nullify
    t = Training.find(1)
    l  = t.posts.size
    assert_no_difference "t.team.posts.length" do
    assert_difference "t.team.posts.find(:all, :conditions=>['training_id is not null']).length", -l do
      t.destroy
    end
    end
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
      trainings(:training1).destroy
    end
  end
end
