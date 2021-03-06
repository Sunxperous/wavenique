Wavenique::Application.routes.draw do
  root to: 'home#index'

	resources :users
	resources :compositions, only: [:index, :show] do
    match '/find', on: :collection, action: :find
    match '/merge', via: :put, on: :member, action: :merge
  end
  resources :artists, only: [:index, :show] do
    match '/find', on: :collection, action: :find
    match '/merge', via: :put, on: :member, action: :merge
    resources :aliases, only: [:index, :new, :create], controller: 'artist_aliases'
  end
	resources :youtube, controller: :youtube, except: [:create, :new] do
		member do
			#match '/create', as: :create, via: :post, action: :create
			#match '/new', as: :new, via: :get, action: :new
		end
	end
  namespace :tsunami do
    resources :users, only: [:index]
  end
  scope '/callback' do
    match 'google', to: 'sessions#google'
  end

  match 'tsunami', to: 'tsunami#index'
	match 'signout', to: 'sessions#destroy'
  match 'search', to: 'youtube#search', via: :get
  match 'modify/:type/:id', to: 'performances#modify', via: :put, as: :modify

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
