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

  def test_team_merge
    juven = official_teams(:juven)

    assert juven.description.blank?
    assert_equal 7, juven.category
    assert_equal OfficialTeam::DEFAULT_IMAGE, juven.image
    assert_equal "/images/official_teams/00/00/00/04.not_image", official_teams(:juven_duplicate).image(nil, :refresh)

    juven.merge(official_teams(:juven_duplicate))
    assert !juven.description.blank?
    assert_equal official_teams(:juven_duplicate).description, juven.description
    assert_equal official_teams(:juven_duplicate).category, juven.category
    assert_equal "/images/official_teams/00/00/00/04.not_image", juven.image(nil, :refresh)
    assert_equal "/images/official_teams/00/00/00/04.not_image", juven.image

    juven.merge(official_teams(:juven_duplicate2))
    assert !juven.description.blank?
    assert_equal official_teams(:juven_duplicate).description, juven.description
    assert_equal official_teams(:juven_duplicate).category, juven.category
    assert_equal "/images/official_teams/00/00/00/04.not_image", juven.image(nil, :refresh)
    assert_equal "/images/official_teams/00/00/00/04.not_image", juven.image
  end

  def test_team_merge_modify_match
    assert_no_difference "OfficialMatch.count" do
    assert_no_difference "OfficialMatch.find(:all, :conditions=>['host_official_team_id=? or guest_official_team_id=?', official_teams(:inter).id, official_teams(:inter).id]).length" do
    assert_no_difference "OfficialMatch.find(:all, :conditions=>['host_official_team_id=? or guest_official_team_id=?', official_teams(:milan).id, official_teams(:milan).id]).length" do
    assert_difference "OfficialMatch.find(:all, :conditions=>['host_official_team_id=?', official_teams(:juven_duplicate).id]).length", -2 do
    assert_difference "OfficialMatch.find(:all, :conditions=>['guest_official_team_id=?', official_teams(:juven_duplicate).id]).length", -2 do
      official_teams(:juven).merge(official_teams(:juven_duplicate))
      assert_equal official_matches(:juvd_inter).host_team, official_teams(:juven)
      assert_equal official_matches(:juvd_milan).host_team, official_teams(:juven)
      assert_equal official_matches(:milan_juvd).guest_team, official_teams(:juven)
      assert_equal official_matches(:inter_juvd).guest_team, official_teams(:juven)
    end
    end
    end
    end
    end
  end
end
