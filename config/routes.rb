ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)
  map.welcome 'welcome/index', :controller => 'welcome', :action => 'index'

  map.search 'search/:type/:course/:terms', :controller => 'search', :action => 'show'
  map.blank_search 'search/:type/:course', :controller => 'search', :action => 'show'
  map.new_search 'search/new', :controller => 'search', :action => 'new'

  map.activate "users/:user_id/activate/:code", :controller => "users/activations", :action => "update", :conditions => { :method => :get }


  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products
  map.resource :session
  map.resources :users
  map.resource :activation, :controller => "users/activations", :only => [:new, :create]


  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  map.resources :recipes, :has_many => :comments

  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
