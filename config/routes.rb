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
  map.resources :users, :collection => { :search => :get } do |users|
    users.resources :teams,:collection =>{:admin => :get} do |teams|
      teams.resources :team_joins
    end
    users.resources :team_join_requests
    users.resources :team_join_invitations
    users.resources :trainings
  end 
  map.resources :user_views
  
  map.resources :teams, :collection => { :search => :get } do |teams|
    teams.resources :users
    teams.resources :team_join_requests
    teams.resources :team_join_invitations
    teams.resources :trainings
  end
  map.resources :team_views
  
  map.resources :trainings do |trainings|
    trainings.resources :users
    trainings.resources :training_joins
  end
  
  map.resources :team_join_requests
  map.resources :team_join_invitations
  map.resources :team_joins
  
  map.resources :sessions
  map.resources :friend_relations
  map.resources :friend_invitations
  map.resources :messages
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
