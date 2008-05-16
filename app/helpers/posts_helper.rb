module PostsHelper  
  def post_icon_link(post)
    post.icon.nil? ? "&nbsp;" :
      link_to(image_tag(post.icon, :title=> post.img_title), post.activity)
  end
end
