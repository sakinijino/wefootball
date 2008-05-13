require File.dirname(__FILE__) + '/../test_helper'

class OfficalTeamImageTest < ActiveSupport::TestCase
  def test_before_save
    offical_team_images(:inter_image).filename = "12345678.not_an_image"
    assert_equal "/images/offical_teams/12/34/56/78.not_an_image", offical_team_images(:inter_image).public_filename
    offical_team_images(:inter_image).save!
    assert_equal "/images/offical_teams/12/34/56/78.not_an_image", offical_teams(:inter).image_path
  end
end
