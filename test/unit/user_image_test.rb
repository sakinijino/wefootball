require File.dirname(__FILE__) + '/../test_helper'

class UserImageTest < ActiveSupport::TestCase
  def test_before_save
    user_images(:saki_image).filename = "u00000003.not_an_image"
    user_images(:saki_image).save!
    users(:saki).image_path = user_images(:saki_image).public_filename
  end
end
