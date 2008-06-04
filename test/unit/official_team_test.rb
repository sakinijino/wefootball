require File.dirname(__FILE__) + '/../test_helper'

class OfficialTeamTest < ActiveSupport::TestCase
  def test_image_path
    assert_equal OfficialTeam::DEFAULT_IMAGE, official_teams(:inter).image
    assert_equal OfficialTeam::DEFAULT_IMAGE, official_teams(:milan).image
    assert_equal "/images/official_teams/00/00/00/01.not_image", official_teams(:inter).image(nil, :refresh)
    assert_equal OfficialTeam::DEFAULT_IMAGE, official_teams(:milan).image(nil, :refresh)
    assert_equal "/images/official_teams/00/00/00/01.not_image", official_teams(:inter).image
    assert_equal OfficialTeam::DEFAULT_IMAGE, official_teams(:milan).image
  end
  
  def test_before_validation
    official_teams(:inter).update_attributes!({:name => 'AC Milan', 
        :description => 'summary'*1000 })
    assert official_teams(:inter).valid?
    assert_equal 3000, official_teams(:inter).description.length
    assert_equal 7, official_teams(:inter).category
  end
  
  def test_user_destroy_dependency_nullify
    u = users(:saki)
    l  = u.official_teams.size
    assert_no_difference "OfficialTeam.count" do
    assert_difference "OfficialTeam.find(:all, :conditions=>['user_id is null']).length", l do
      u.destroy
    end
    end
  end
end
