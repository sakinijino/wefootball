module PostsHelper
  def new_post_path2
    if (@match)
      match_team_posts_path(@match, @team)
    elsif (@training)
      training_posts_path(@training)
    elsif (@sided_match)
      sided_match_posts_path(@sided_match)
    elsif (@team)
      team_posts_path(@team)
    else
      posts_path
    end
  end
end
