atom_feed(:root_url => team_posts_url(@team), :language=>'zh-CN') do |feed|
  feed.title @title
  feed.updated((@posts.first.created_at))

  for post in @posts
    feed.entry(post) do |entry|
      entry.title post.title
      entry.content simple_format(post.content), :type=>'html'
      entry.author do |author|
        author.name(post.user.nickname)
      end
    end
  end
end

