SampleApp::Application.routes.draw do

#map GET static_pages/home to StaticPages controller with action home
#get "static_pages/home"

#the "/" is a special case
  root to: 'static_pages#home'

#map GET /help to StaticPages controller with action help
#create automatically the variable help_path="/help doe use in controllers/views & specs
  match '/help',    to: 'static_pages#help'
  match '/about',   to: 'static_pages#about'
  match '/contact', to: 'static_pages#contact'

# users controller (REST)
  resources :users #endow app with all actions needed for a RESTful users resource

  # controller is "users_controller"
  # HTTP requests       Action   Named route   purpose
  #  GET /users         index    users_path    page to list all users
  #  GET /users/1       show     user_path(user) page to show user
  #  GET /users/new     new      new_user_path page to make a new user (signup)
  #  POST  /users       create   users_path  create a new user
  #  GET /users/1/edit  edit     edit_user_path(user)  page to edit user with id 1
  #  PUT /users/1       update   user_path(user) update user
  #  DELETE  /users/1   destroy  user_path(user) delete user
  # also creastes user_path as /users
  match '/signup', to: 'users#new'

#sessions controller (REST)
resources :sessions, only: [:new, :create, :destroy]  
match '/signin',  to: 'sessions#new'
#force HTTP method DELETE
match '/signout', to: 'sessions#destroy', via: :delete

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
