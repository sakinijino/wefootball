ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.
  
  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action
  
  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)
  
  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products
  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }
  
  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end
  
  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"
  
  # See how all your routes lay out with "rake routes"
  
  # Install the default routes as the lowest priority.
  map.resources :users, 
    :collection => { :search => :post, :invite => :get, :create_with_invitation => :post }, 
    :member => {:update_image => :put} do |users|
    users.resources :friend_relations
    users.resources :team_join_invitations
    users.resources :team_joins
    users.resources :match_reviews
  end 
  map.resources :user_views
  
  map.resources :broadcasts  
  
  map.resources :sessions
  map.resources :friend_relations
  map.resources :friend_invitations
  map.resources :messages, :collection => { :destroy_multi => :delete }
  map.send_message_to '/messages/to/:to', :controller => 'messages', :action => 'new'
  
  map.resources :teams, :collection => { :search => :post }, :member => {:update_image => :put} do |teams|
    teams.resources :team_joins
    teams.resources :team_join_requests
    teams.resources :team_join_invitations
    teams.resources :trainings
    teams.resources :posts
    teams.resources :matches
    teams.resources :sided_matches    
    teams.resources :match_invitations    
  end
  map.resources :team_views
  
  map.resources :team_join_requests
  map.resources :team_join_invitations
  map.resources :team_joins, 
    :collection => { 
      :formation_index => :get,
      :admin_management => :get, 
      :player_management => :get, 
      :formation_management => :get,
      :update_formation => :put
    }
  
  map.resources :trainings,
    :member => {:undetermined_users=>:get, :joined_users=>:get} do |trainings|
    trainings.resources :training_joins
    trainings.resources :posts
  end
  
  map.resources :match_invitations
  map.resources :matches, :member => {:undetermined_users=>:get, :joined_users=>:get} do |matches|
    matches.resources :team do |teams|
      teams.resources :posts
    end
    matches.resources :match_reviews
  end
  map.resources :match_joins, :collection => { :update_formation => :put }

  map.resources :sided_matches,
    :member => {:edit_result =>:get, :update_result=>:put, :undetermined_users=>:get, :joined_users=>:get} do |sided_matches|
    sided_matches.resources :sided_match_joins
    sided_matches.resources :posts
    sided_matches.resources :match_reviews
  end
  map.resources :sided_match_joins, :collection => { :edit_formation => :get, :update_formation => :put }
  
  map.resources :plays, :member => {:players=>:get} do |plays|
    plays.resources :play_joins
  end  
  
  map.resources :posts, :collection => { :related => :get } do |posts|
    posts.resources :replies
  end
  
  map.resources :watches, :member => {:users=>:get, :select_new_admin => :get} do |watches|
    watches.resources :watch_joins
    watches.resources :posts
  end
  map.resources :watch_joins, :member => {:destroy_admin => :delete}
  
  map.resources :football_grounds, :collection => { :unauthorize => :get }
  
  map.resources :site_posts do |site_posts|
    site_posts.resources :site_replies
  end
  
  map.resources :official_teams, :member => {:update_image => :put}
  map.resources :official_matches do |om|
    om.resources :match_reviews
    om.resources :watches
  end
  
  map.resources :match_reviews do |mr|
    mr.resources :match_review_replies
    mr.resources :match_review_recommendations
  end
  
  map.site_index "/", :controller => 'application', :action => 'index'
  map.site_about "/about", :controller => 'application', :action => 'about'
  map.site_faq "/faq", :controller => 'application', :action => 'faq'
  
  map.user_month_calendar "users/:user_id/calendar/:year/:month", :controller=>"calendar", :action => "show_a_month",
      :requirements => {:year => /(19|20)\d\d/, :month => /[01]?\d/}
  map.user_day_calendar "users/:user_id/calendar/:year/:month/:day", :controller=>"calendar", :action => "show_a_day",
      :requirements => {:year => /(19|20)\d\d/, :month => /[01]?\d/, :day => /[0-3]?\d/}
  map.team_month_calendar "teams/:team_id/calendar/:year/:month", :controller=>"calendar", :action => "show_a_month",
      :requirements => {:year => /(19|20)\d\d/, :month => /[01]?\d/}
  map.team_day_calendar "teams/:team_id/calendar/:year/:month/:day", :controller=>"calendar", :action => "show_a_day",
      :requirements => {:year => /(19|20)\d\d/, :month => /[01]?\d/, :day => /[0-3]?\d/}
    
  map.user_icalendar "users/:id/icalendar.ics", :controller=>"i_calendar", :action => "user"
  map.team_icalendar "teams/:id/icalendar.ics", :controller=>"i_calendar", :action => "team"
    
  map.province_city_select "js/province_city_select.js", :controller=>"js", :action => "province_city_select"
  map.football_ground_select "js/football_ground_select.js", :controller=>"js", :action => "football_ground_select"
  
  map.activate '/activate/:activation_code', :controller => 'users', :action=> 'activate', :activation_code => nil
  map.signup_with_invitation '/signup_with_invitation/:invitation_code', :controller => 'users', :action=> 'new_with_invitation', :invitation_code => nil  
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.forgot_password '/forgot_password', :controller => 'users', :action => 'forgot_password' 
  map.reset_password '/reset_password/:password_reset_code', :controller => 'users', :action => 'reset_password', :password_reset_code => nil  
  map.resend_activate_mail '/resend_activate_mail', :controller => 'users', :action => 'resend_activate_mail'  
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
