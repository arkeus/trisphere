Trisphere::Application.routes.draw do
  root "index#index"
  
  # Index
  post "/login" => "index#login"
  get "/logout" => "index#logout"
  
  # Character
  get "/character" => "character#home"
  
  # Inventory
  get "/inventory" => "inventory#index"
  
  # Forums
  constraints category_id: /\d+/, topic_id: /\d+/, post_id: /\d+/ do
	  get "/forums" => "forums#index"
	  get "/forums/post/:category_id/(:topic_id)/(:post_id)" => "forums#post"
	  post "/forums/post/:category_id/(:topic_id)/(:post_id)" => "forums#post"
	  post "/forums/make_post/:category_id" => "forums#make_post"
	  get "/forums/:category_id" => "forums#category"
	  get "/forums/:category_id/:topic_id" => "forums#topic"
	  get "/forums/delete/:category_id/:topic_id/:id" => "forums#delete"
	  get "/forums/:alter_type/:category_id/:topic_id" => "forums#alter", constraints: { alter_type: /sticky|unsticky|lock|unlock/ }
	end
  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
