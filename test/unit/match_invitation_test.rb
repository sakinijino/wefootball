require File.dirname(__FILE__) + '/../test_helper'

class MatchInvitationTest < ActiveSupport::TestCase
  
  def test_length_validation
    m = match_invitations(:inv1)
    assert m.valid?
    m.new_start_time = 2.days.ago
    m.new_half_match_length = 12*60
    m.new_half_match_length = 10
    assert !m.valid?
  end
  
  def test_outdated
    m = match_invitations(:inv1)
    m.new_start_time = 2.days.ago
    m.new_location = "Beijing"
    m.new_half_match_length = 45
    m.new_rest_length = 15
    m.save_without_validation!
    assert m.outdated?
  end

  def test_host_team_and_guest_team #测试到host_team和guest_team的关联正确
    m = match_invitations(:inv1)
    m.host_team_id = teams(:inter).id
    m.guest_team_id = teams(:milan).id
    assert_equal m.host_team,teams(:inter)
    assert_equal m.guest_team,teams(:milan)    
  end
  
  def test_accessible_attr #测试attr_accessible，以description和new_description为例
    m = match_invitations(:inv1)
    assert_equal nil, m.description
    assert_equal 'Hello', m.new_description
    m.update_attributes!(:description=>"test2",:new_description=>"test2")
    assert_equal nil, m.description
    assert_equal "test2", m.new_description
    m.description = "test2"
    m.save!
    assert_equal "test2", m.description
  end 
  
  def test_before_validation #测试before_validation   
    m1 = MatchInvitation.new
    m1.new_location = "Beijing"
    m1.new_start_time = 1.day.since
    m1.new_half_match_length = 45
    m1.new_rest_length = 15
    m1.save!
    assert_equal "", m1.host_team_message
    assert_equal "", m1.guest_team_message    
    assert_equal "", m1.new_description
    assert_equal 5, m1.new_size
    assert_equal 1, m1.new_match_type
    assert_equal 1, m1.new_win_rule
    
    m2 = match_invitations(:inv1)
    m2.update_attributes!({:new_description =>'s'*4000})
    m2.host_team_message = 't'*2000
    m2.save!
    assert_equal m2.new_description.length,MatchInvitation::MAX_DESCRIPTION_LENGTH
    assert_equal m2.host_team_message.length,MatchInvitation::MAX_TEAM_MESSAGE_LENGTH 
  end  
  
  def test_save_last_info #测试save_last_info！
    m = match_invitations(:inv1)
    time = 1.day.since
    m.update_attributes!({
        :new_start_time => time,
        :new_location => "北大一体",
        :new_match_type => 1,
        :new_size => 5,
        :new_has_judge => true,
        :new_has_card => false,
        :new_has_offside => true,
        :new_win_rule => 2,
        :new_description => "阿森纳版踢",
        :new_half_match_length => 20,
        :new_rest_length => 10
      })    
    m.save_last_info!
    assert_equal m.start_time, time
    assert_equal m.location,"北大一体"
    assert_equal m.match_type,1
    assert_equal m.size,5
    assert_equal m.has_judge,true
    assert_equal m.has_card,false
    assert_equal m.has_offside,true
    assert_equal m.win_rule,2    
    assert_equal m.description,"阿森纳版踢"  
    assert_equal m.half_match_length,20
    assert_equal m.rest_length,10    
  end
#  
  def test_has_been_modified #has_been_modified？
    m = match_invitations(:inv1)
    m.update_attributes!(:new_location => "北大一体")
    assert_equal m.has_been_modified?(:new_location=>"北大一体"), false
    assert_equal m.has_been_modified?(:new_location=>"北大二体"), true 
  end
  
  def test_has_attribute_been_modified #测试has_attribute_been_modified?
    m = match_invitations(:inv1)
    m.size = 5
    m.save!
    m.save_last_info!
    m.update_attributes!(:new_size => 6)
    assert_equal m.has_attribute_been_modified?(:size), true
    m.save_last_info!
    m.update_attributes!(:new_size => 6)
    assert_equal m.has_attribute_been_modified?(:size), false
    
    m = MatchInvitation.new
    m.new_location = "北大一体"
    m.save!
    assert_equal false, m.has_attribute_been_modified?(:location)
    assert_equal false, m.has_attribute_been_modified?(:football_ground_id)
    m = MatchInvitation.new
    m.new_football_ground_id = 1
    m.save!
    assert_equal false, m.has_attribute_been_modified?(:location)
    assert_equal false, m.has_attribute_been_modified?(:football_ground_id)
    
    m = MatchInvitation.new
    m.new_location = "北大一体"
    m.save_last_info!
    m.update_attributes!(:new_location => "北大二体", :new_football_ground_id=>nil)
    assert m.has_attribute_been_modified?(:location)
    assert m.has_attribute_been_modified?(:football_ground_id)
    m.save_last_info!
    m.update_attributes!(:new_location => "北大二体", :new_football_ground_id=>nil)
    assert !m.has_attribute_been_modified?(:location)
    assert !m.has_attribute_been_modified?(:football_ground_id)
    m.save_last_info!
    m.update_attributes!(:new_football_ground_id => 1, :new_location =>nil)
    assert m.has_attribute_been_modified?(:location)
    assert m.has_attribute_been_modified?(:football_ground_id)
    m.save_last_info!
    m.update_attributes!(:new_football_ground_id => 2, :new_location =>nil)
    assert m.has_attribute_been_modified?(:location)
    assert m.has_attribute_been_modified?(:football_ground_id)
    m.save_last_info!
    m.update_attributes!(:new_football_ground_id => 2, :new_location =>nil)
    assert !m.has_attribute_been_modified?(:location)
    assert !m.has_attribute_been_modified?(:football_ground_id)
    m.save_last_info!
    m.update_attributes!(:new_location => "北大二体", :new_football_ground_id=>nil)
    assert m.has_attribute_been_modified?(:location)
    assert m.has_attribute_been_modified?(:football_ground_id)
  end

  def test_match_invitations_count
    m = MatchInvitation.new
    assert_no_difference "teams(:inter).reload.match_invitations_count" do
    assert_difference "teams(:milan).reload.match_invitations_count", 1 do
      m.host_team = teams(:inter)
      m.guest_team = teams(:milan)
      m.new_location = "北大一体"
      m.save!
    end
    end
    
    assert_difference "teams(:inter).reload.match_invitations_count", 1 do
    assert_difference "teams(:milan).reload.match_invitations_count", -1 do
      m.edit_by_host_team = !m.edit_by_host_team
      m.save!
    end
    end
    
    assert_difference "teams(:inter).reload.match_invitations_count", -1 do
    assert_difference "teams(:milan).reload.match_invitations_count", 1 do
      m.edit_by_host_team = !m.edit_by_host_team
      m.save!
    end
    end
    
    assert_no_difference "teams(:inter).reload.match_invitations_count" do
    assert_difference "teams(:milan).reload.match_invitations_count", -1 do
      m.destroy
    end
    end
    
    m = MatchInvitation.new
    assert_no_difference "teams(:inter).reload.match_invitations_count" do
    assert_difference "teams(:milan).reload.match_invitations_count", 1 do
      m.host_team = teams(:inter)
      m.guest_team = teams(:milan)
      m.new_location = "北大一体"
      m.save!
    end
    end
    
    assert_difference "teams(:inter).reload.match_invitations_count", 1 do
    assert_difference "teams(:milan).reload.match_invitations_count", -1 do
      m.edit_by_host_team = !m.edit_by_host_team
      m.save!
    end
    end
    
    assert_difference "teams(:inter).reload.match_invitations_count", -1 do
    assert_no_difference "teams(:milan).reload.match_invitations_count" do
      m.destroy
    end
    end
  end
end
