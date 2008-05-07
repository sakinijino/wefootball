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
  
  def post_icon_link(post)
    if !post.training_id.nil?
      training_icon_link(post.training_id)
    elsif !post.match_id.nil?
      match_icon_link(post.match_id)
    elsif !post.sided_match_id.nil?
      sided_match_icon_link(post.sided_match_id)
    else
      "&nbsp;"
    end
  end
end
