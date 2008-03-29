require File.dirname(__FILE__) + '/../test_helper'

class MatchInvitationTest < ActiveSupport::TestCase

  def test_host_team_and_guest_team #测试到host_team和guest_team的关联正确
    m = match_invitations(:inv1)
    m.host_team_id = teams(:inter).id
    m.guest_team_id = teams(:milan).id
    assert_equal m.host_team,teams(:inter)
    assert_equal m.guest_team,teams(:milan)    
  end
  
  def test_accessible_attr #测试attr_accessible，以description和new_description为例
    m = match_invitations(:inv1)
    assert_equal m.description,nil
    assert_equal m.new_description,'test'   
    m.update_attributes(:description=>"test2",:new_description=>"test2")
    assert_equal m.description,nil
    assert_equal m.new_description,"test2"
    m.description = "test2"
    m.save
    assert_equal m.description,"test2"    
  end
 
  
  def test_before_validation #测试before_validation   
    m1 = MatchInvitation.create
    assert_equal m1.host_team_message,""
    assert_equal m1.guest_team_message,""    
    assert_equal m1.new_description,""  
    
    m2 = match_invitations(:inv1)
    m2.update_attributes({:new_description =>'s'*2000})
    m2.host_team_message = 't'*2000
    m2.save!
    assert_equal m2.new_description.length,MatchInvitation::MAX_DESCRIPTION_LENGTH
    assert_equal m2.host_team_message.length,MatchInvitation::MAX_TEAM_MESSAGE_LENGTH 
  end  
  
  def test_save_last_info #测试save_last_info！
    m = match_invitations(:inv1)
    m.update_attributes({
        :new_start_time => "2008-3-1 14:00",
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
    assert_equal m.start_time.to_s(:db),"2008-03-01 14:00:00"
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
    m.update_attributes(:new_location => "北大一体")
    assert_equal m.has_been_modified?(:new_location=>"北大一体"), false
    assert_equal m.has_been_modified?(:new_location=>"北大二体"), true 
  end
  
  def test_has_attribute_been_modified #测试has_attribute_been_modified?
    m = match_invitations(:inv1)
    m.location = "北大一体"
    m.save
    m.update_attributes(:new_location => "北大二体")
    assert_equal m.has_attribute_been_modified?(:location), true
    m.update_attributes(:new_location => "北大一体")    
    assert_equal m.has_attribute_been_modified?(:location), false     
  end

end
