Trisphere::Application.routes.draw do
  root "index#index"
  
  # Index
  post "/login" => "index#login"
  get "/logout" => "index#logout"
  
  # Character
  scope "/character" do
  	get "/" => "character#home"
 	end
  
  # Friends
  scope "/friends" do
  	get "/" => "friends#index"
  end
  
  # Inventory
  scope "/inventory" do
	  get "/" => "inventory#index"
	  get "/bags" => "inventory#bags"
	  get "/equipped" => "inventory#equipped"
	  get "/reset" => "inventory#reset"
	end
  
  # Forums
  scope "/forums" do
	  constraints category_id: /\d+/, topic_id: /\d+/, post_id: /\d+/ do
		  get "/" => "forums#index"
		  get "/post/:category_id/(:topic_id)/(:post_id)" => "forums#post"
		  post "/post/:category_id/(:topic_id)/(:post_id)" => "forums#post"
		  post "/make_post/:category_id" => "forums#make_post"
		  get "/:category_id" => "forums#category"
		  get "/:category_id/:topic_id" => "forums#topic"
		  get "/delete/:category_id/:topic_id/:id" => "forums#delete"
		  get "/:alter_type/:category_id/:topic_id" => "forums#alter", constraints: { alter_type: /sticky|unsticky|lock|unlock/ }
		end
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
