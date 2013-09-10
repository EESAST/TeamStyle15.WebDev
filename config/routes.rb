TeamStyle15Webdev::Application.routes.draw do
  
  resources :messages,:only=>[:index]
  delete 'messages/:id' => 'messages#delete'

  resources :news,:only=>[:index,:delete,:destroy,:edit,:update,:create,:new]

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end

  resources :teams
  resources :comments,:only=>[:index,:delete,:destroy,:edit,:update,:create]
  resources :posts
  resources :users

  get 'admin' => 'admin#index'
  get "user/index"
  get "user/userpost"
  get "user/team"
  get "admin/index"
  get "sessions/new"
  get "sessions/create"
  get "sessions/destroy"
  
  match "home/index" => redirect("/"), :via=>:get
  match "comments/new" => redirect("/"), :via=>:get, :notice=>'不可以直接发表评论'
  match "comments/new" => redirect("/"), :via=>:post, :notice=>'不可以直接发表评论'
  
  get 'teams/:team_id/add/:user_id' => 'teams#add_member'
  delete 'teams/:team_id/kick/:user_id' => 'teams#kick_member'

  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
