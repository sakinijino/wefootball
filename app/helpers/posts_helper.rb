module PostsHelper
  def new_post_path2
    if (@team)
      team_posts_path(@team)
    elsif (@training)
      training_posts_path(@training)
    else
      posts_path
    end
  end
end
