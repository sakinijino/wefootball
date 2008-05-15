require File.dirname(__FILE__) + '/../test_helper'

class OfficialTeamImageTest < ActiveSupport::TestCase
  def test_before_save
    official_team_images(:inter_image).filename = "12345678.not_an_image"
    assert_equal "/images/official_teams/12/34/56/78.not_an_image", official_team_images(:inter_image).public_filename
    official_team_images(:inter_image).save!
    assert_equal "/images/official_teams/12/34/56/78.not_an_image", official_teams(:inter).image_path
  end
end
