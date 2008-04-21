require File.dirname(__FILE__) + '/../test_helper'

class TeamImageTest < ActiveSupport::TestCase
  def test_before_save
    team_images(:inter_image).filename = "12345678.not_an_image"
    assert_equal "/images/teams/12/34/56/78.not_an_image", team_images(:inter_image).public_filename
    team_images(:inter_image).save!
    assert_equal "/images/teams/12/34/56/78.not_an_image", teams(:inter).image_path
  end
end
