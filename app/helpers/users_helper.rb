module UsersHelper
   FITFOOT_TEXT = {'L'=>'左脚', 'R'=>'右脚', 'B'=>'左右开弓'}
   POSITION_TEXT =[
     '门将', '清道夫', '中后卫', '左后卫', '右后卫', '后腰', '中前卫', '左前卫', '右前卫', '前腰', '中锋', '二前锋', '左边锋', '右边锋'
    ]
  def fitfoot_text(label)
   UsersHelper::FITFOOT_TEXT[label]
  end
  
  def position_text(label)
    UsersHelper::POSITION_TEXT[label]
  end
  
  def user_image_tag(user, options={})
    image_tag(user.image, {:width=>UserImage::WIDTH, :height=>UserImage::HEIGHT, :title=>user.nickname}.merge(options))
  end
  
  def user_image_link(user, options={})
    link_to user_image_tag(user, options), user_view_path(user.id)
  end
  
  def small_user_image_tag(user, options={})
    image_tag(user.image(:small), {:width=>UserImage::SMALL_WIDTH, :height=>UserImage::SMALL_HEIGHT,
      :class=>"icon", :title=>user.nickname}.merge(options))
  end
  
  def small_user_image_link(user, options={})
    link_to small_user_image_tag(user, options), user_view_path(user.id)
  end
end