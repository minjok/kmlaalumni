Kmlaalumni::Application.routes.draw do
  
  #	*** ROOT ***	#
  root to: 'home#index'
  
  
  #	*** DEVISE ***	#
  devise_for :users, controllers: { registrations: 'users/registrations' }

  devise_scope :user do
	get 	'signup',	to: 'devise/registrations#new',		as: 'signup'
	get 	'login',	to: 'devise/sessions#new',			as: 'login'
	delete	'logout',	to: 'devise/sessions#destroy',		as: 'logout'
  end
  
  
  #	*** RESOURCES ***	#
  resources :groups do
	resources :postings
  end
    
  resources :postings do
    resources :comments
    
    collection do
      get :feed
      get :num_pages
    end
  end
  
  resources :membership do
	
	member do
		post :add
		post :delete
	end
	
  end
  
  
  #	*** SIMPLIFIED ROUTES ***	#
  match '/welcome', 			to: 'home#welcome', 		as: 'welcome'
  match '/add_member/:id',		to: 'membership#add', 		as: 'add_member'
  match '/delete_member/:id', 	to: 'membership#delete', 	as: 'delete_member'
  
  
  
  
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

  

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
