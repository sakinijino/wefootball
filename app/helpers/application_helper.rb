# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def user_image_tag(user)
    image_tag(user.image, :width=>UserImage::WIDTH, :height=>UserImage::HEIGHT)
  end
  
  def team_image_tag(team)
    image_tag(team.image, :width=>TeamImage::WIDTH, :height=>TeamImage::HEIGHT)
  end
end
