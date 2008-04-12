module UsersHelper
   FITFOOT_TEXT = {'L'=>'左脚', 'R'=>'右脚', 'B'=>'左右开弓'}
   POSITION_TEXT =[
     '门将', '清道夫', '中后卫', '左后卫', '右后卫', '后腰', '中前卫', '左前卫', '右前卫', '前腰', '中锋', '左边锋', '右边锋', '二前锋'
    ]
  
  def smart_nickname(user)
    user == current_user ? '我' : h(user.nickname)
  end
  
  def fitfoot_text(label)
   UsersHelper::FITFOOT_TEXT[label]
  end
  
  def position_text(label)
    UsersHelper::POSITION_TEXT[label]
  end
  
  def user_image_tag(user, options={})
    image_tag(user.image, {:width=>UserImage::WIDTH, :height=>UserImage::HEIGHT, :title=>h(user.nickname)}.merge(options))
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
  
  def tiny_user_image_tag(user, options={})
    image_tag(user.image(:tiny), {:width=>UserImage::TINY_WIDTH, :height=>UserImage::TINY_HEIGHT,
      :class=>"icon", :title=>user.nickname}.merge(options))
  end
  
  def tiny_user_image_link(user, options={})
    link_to tiny_user_image_tag(user, options), user_view_path(user.id)
  end
  
  def user_icon(user)
    content = ''
    case user
    when User
      content << %(
      <div class="icon">
        #{small_user_image_link user}
        <span>#{link_to h(user.nickname), user_view_path(user.id)}</span>
      </div>)
    else
      if user.respond_to?(:each)
        user.each {|u| content << user_icon(u)}
      end
    end
    content
  end
  
  def small_position_icon_position(i)
    return [75, 200] if i<=0
    return [90, 40] if i>=13
    left = case i%4
    when 0
      125
    when 3
      25
    else
      75
    end
    top = case i
    when 1
      180
    when 2,3,4
      163
    when 5
      135
    when 6, 7,8
      100
    when 9
      65
    when 10
      25
    when 11, 12
      35
    end
    [left, top]
  end
end