Kmlaalumni::Application.routes.draw do
  
  #	*** ROOT ***	#
  root to: 'home#index'
  
  
  #	*** DEVISE ***	#
  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }

  devise_scope :user do
	get 	'/signup',	to: 'users/registrations#new',		as: 'signup'
	get 	'/login',	to: 'users/sessions#new',			as: 'login'
	delete	'/logout',	to: 'devise/sessions#destroy',		as: 'logout'
    
    get     '/verify_alumni', to: 'users/registrations#verify_alumni', as: 'verify_alumni'
    get     '/settings',      to: 'devise/registrations#edit',         as: 'settings'
    get     '/profile/:id',       to: 'users/registrations#show',          as: 'profile'
    
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
  
  resources :comments do
    collection do
      get :feed
    end
  end
  
  resources :educations
  
  resources :employments
  
  #	*** ROUTES ***	#
  match '/welcome',             to: 'home#welcome',               as: 'welcome'
  
  match '/announcement',        to: 'association#announcement',         as: 'announcement'
  match '/newsletter',          to: 'association#newsletter',           as: 'newsletter'
  match '/regulations',         to: 'association#regulations',          as: 'regulations'
    
  match '/add_member/:id',      to: 'membership#add',             as: 'add_member'
  match '/delete_member/:id',   to: 'membership#delete',          as: 'delete_member'
  
  match '/destroy_group/:id',   to: 'groups#destroy',              as: 'destroy_group'
  
  match 'get_posting_content/:id', to: 'postings#get_content', as: 'get_posting_content'
  match 'get_posting_likes/:id', to: 'postings#get_likes', as: 'get_posting_likes'
  
  match 'get_comment_content/:id', to: 'comments#get_content', as: 'get_comment_content'
  match 'get_comment_likes/:id', to: 'comments#get_likes', as: 'get_comment_likes'
  
  match '/like_posting/:id',            to: 'postings#like',                  as: 'like_posting'
  match '/dislike_posting/:id',         to: 'postings#dislike',               as: 'dislike_posting'
  match '/like_comment/:id',            to: 'comments#like',                  as: 'like_comment'
  match '/dislike_comment/:id',         to: 'comments#dislike',               as: 'dislike_comment'
  
  match '/get_add_education_form', to: 'settings#get_add_education_form',   as: 'get_add_education_form'
  match '/get_add_employment_form', to: 'settings#get_add_employment_form', as: 'get_add_employment_form'
  
  match '/destroy_education/:id', to: 'educations#destroy', as: 'destroy_education'
  match '/destroy_employment/:id', to: 'employments#destroy', as: 'destroy_employment'
  
  match '/network',             to: 'network#index',              as: 'network'
  match '/network_school',      to: 'network#school',              as: 'network_school'
  match '/network_organization',to: 'network#organization',        as: 'network_organization'
  
  match '/search_alumni',       to: 'network#search_alumni',             as: 'search_alumni'
  match '/search_school/:id',   to: 'network#search_school',             as: 'search_school'
  match '/search_organization/:id',   to: 'network#search_organization',             as: 'search_organization'
  match '/get_everyone',        to: 'network#get_everyone',       as: 'get_everyone'
  
  
  
  
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
