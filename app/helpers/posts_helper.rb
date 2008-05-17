module PostsHelper  
  def post_icon_link(post)
    post.icon.nil? ? "&nbsp;" :
      link_to(image_tag(post.icon, :title=> post.img_title), post.activity)
  end
  
  def post_sidebar_menu(act)
    case @activity 
     when Training
      "#{render :partial=>'posts/sidebar_menu_training'}"
    when SidedMatch
      "#{render :partial=>'posts/sidebar_menu_sided_match'}"
    when Match
      "#{render :partial=>'posts/sidebar_menu_match'}"
    else
      "#{render :partial=>'posts/sidebar_menu_team'}"
    end
  end
end
