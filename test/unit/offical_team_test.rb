require File.dirname(__FILE__) + '/../test_helper'

class OfficalTeamTest < ActiveSupport::TestCase
  def test_image_path
    assert_equal OfficalTeam::DEFAULT_IMAGE, offical_teams(:inter).image
    assert_equal OfficalTeam::DEFAULT_IMAGE, offical_teams(:milan).image
    assert_equal "/images/offical_teams/00/00/00/01.not_image", offical_teams(:inter).image(nil, :refresh)
    assert_equal OfficalTeam::DEFAULT_IMAGE, offical_teams(:milan).image(nil, :refresh)
    assert_equal "/images/offical_teams/00/00/00/01.not_image", offical_teams(:inter).image
    assert_equal OfficalTeam::DEFAULT_IMAGE, offical_teams(:milan).image
  end
  
  def test_before_validation
    offical_teams(:inter).update_attributes!({:name => 'AC Milan', 
        :description => 'summary'*1000 })
    assert offical_teams(:inter).valid?
    assert_equal 3000, offical_teams(:inter).description.length
  end
  
  def test_user_destroy_dependency_nullify
    u = users(:saki)
    l  = u.offical_teams.size
    assert_no_difference "OfficalTeam.count" do
    assert_difference "OfficalTeam.find(:all, :conditions=>['user_id is null']).length", l do
      u.destroy
    end
    end
  end
end
