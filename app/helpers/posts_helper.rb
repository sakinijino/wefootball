module PostsHelper
  def new_post_path2
    if (@training)
      training_posts_path(@training)
    elsif (@team)
      team_posts_path(@team)
    else
      posts_path
    end
  end
end
