require File.dirname(__FILE__) + '/../test_helper'

class UserImageTest < ActiveSupport::TestCase
  def test_before_save
    user_images(:saki_image).filename = "12345678.not_an_image"
    assert_equal "/images/users/12/34/56/78.not_an_image", user_images(:saki_image).public_filename
    user_images(:saki_image).save!
    assert_equal "/images/users/12/34/56/78.not_an_image", users(:saki).image_path
  end
end
