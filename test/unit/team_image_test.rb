require File.dirname(__FILE__) + '/../test_helper'

class TeamImageTest < ActiveSupport::TestCase
  def test_before_save
    team_images(:inter_image).filename = "t00000001.not_an_image"
    team_images(:inter_image).save!
    teams(:inter).image_path = team_images(:inter_image).public_filename
  end
end
