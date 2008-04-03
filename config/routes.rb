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
  map.resources :users, :collection => { :search => :get }, :member => {:update_image => :put} do |users|
    users.resources :friend_relations
    users.resources :team_join_invitations
    users.resources :team_joins
    users.resources :trainings
  end 
  map.resources :user_views
  
  map.resources :teams, :collection => { :search => :get }, :member => {:update_image => :put} do |teams|
    teams.resources :team_joins
    teams.resources :team_join_requests
    teams.resources :team_join_invitations
    teams.resources :trainings
    teams.resources :posts
    teams.resources :matches    
  end
  map.resources :team_views
  
  map.resources :trainings do |trainings|
    trainings.resources :users
    trainings.resources :training_joins
    trainings.resources :posts
  end
  map.resources :training_views
  
  map.resources :team_join_requests
  map.resources :team_join_invitations
  map.resources :team_joins, 
    :collection => { 
      :admin_management => :get, 
      :player_management => :get, 
      :formation_management => :get,
      :update_formation => :put
    }
  
  map.resources :sessions
  map.resources :friend_relations
  map.resources :friend_invitations
  map.resources :messages, :collection => { :destroy_multi => :delete }
  
  map.resources :match_invitations
  map.resources :matches
  map.resources :match_joins, :collection => { :update_all => :put }  
  map.resources :match_views
  
  map.resources :posts do |posts|
    posts.resources :replies
  end
  
  map.resources :football_grounds, :collection => { :unauthorize => :get }
  
  map.user_month_calendar "users/:user_id/calendar/:year/:month", :controller=>"calendar", :action => "show_a_month",
      :requirements => {:year => /(19|20)\d\d/, :month => /[01]?\d/}
  map.user_day_calendar "users/:user_id/calendar/:year/:month/:day", :controller=>"calendar", :action => "show_a_day",
      :requirements => {:year => /(19|20)\d\d/, :month => /[01]?\d/, :day => /[0-3]?\d/}
  map.team_month_calendar "teams/:team_id/calendar/:year/:month", :controller=>"calendar", :action => "show_a_month",
      :requirements => {:year => /(19|20)\d\d/, :month => /[01]?\d/}
  map.team_day_calendar "teams/:team_id/calendar/:year/:month/:day", :controller=>"calendar", :action => "show_a_day",
      :requirements => {:year => /(19|20)\d\d/, :month => /[01]?\d/, :day => /[0-3]?\d/}
    
  map.province_city_select "js/province_city_select.js", :controller=>"js", :action => "province_city_select"
  map.football_ground_select "js/football_ground_select.js", :controller=>"js", :action => "football_ground_select"
  
  map.activate '/activate/:activation_code', :controller => 'users', :action=> 'activate', :activation_code => nil
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.forgot_password '/forgot_password', :controller => 'users', :action => 'forgot_password'
  map.reset_password '/reset_password/:password_reset_code', :controller => 'users', :action => 'reset_password', :password_reset_code => nil  
  
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
