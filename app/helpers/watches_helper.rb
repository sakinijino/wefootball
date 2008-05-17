module WatchesHelper
  def watch_quit_link_by_user(watch, user, text)
    if watch.can_be_edited_by?(user) && watch.watch_join_count > 1
      "#{link_to text, select_new_admin_watch_path(watch)}"
    else
      "#{link_to(text, watch_watch_join_path(watch, 0), :method=>'delete')}"
    end
  end
end
