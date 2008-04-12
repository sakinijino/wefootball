module SidebarMenuHelper
  def selected_sidebar_menu_item(options)
    (options[:boolean].nil? || options[:boolean]) && 
      (options[:controller].nil? || options[:controller] == params[:controller]) && 
      params[:action] == options[:action] ?
    'selected' : ""
  end
  
  def selected_class_sidebar_menu_item(options)
    klass= selected_sidebar_menu_item(options)
    klass.blank? ? '' : "class=#{klass}"
  end
  
  def smart_return_user_view_menu_item(user)
    if @user == current_user
      link_to "返回我的首页", user_view_path(@user)
    else
      link_to "返回#{h @user.nickname}的首页", user_view_path(@user)
    end
  end
end
