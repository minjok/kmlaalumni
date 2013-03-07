Kmlaalumni::Application.routes.draw do
  
  #	*** ROOT ***	#
  root to: 'home#index'
  
  
  #	*** DEVISE ***	#
  devise_for :users, controllers: { registrations: 'users/registrations', sessions: 'users/sessions' }

  devise_scope :user do
	get 	'/signup',	to: 'users/registrations#new',		as: 'signup'
	get 	'/login',	to: 'users/sessions#new',			as: 'login'
    get     '/verify_alumni', to: 'users/registrations#verify_alumni', as: 'verify_alumni'
	delete	'/logout',	to: 'devise/sessions#destroy',		as: 'logout'
  end
  
  
  #	*** RESOURCES ***	#
  resources :groups do
	resources :postings
  end
    
  resources :postings do
    resources :comments
  end
  
  resources :careernotes do
    resources :comments
  end
  
  resources :comments
  
  resources :educations
  
  resources :employments
  
  resources :settings
    
  #	*** ROUTES ***	#
  match '/welcome',             to: 'home#welcome',               as: 'welcome'
  
  match '/activity_num_pages', to: 'activities#num_pages', as: 'activity_num_pages'
  match '/activity_feed', to: 'activities#feed', as: 'activity_feed'
  
  match '/announcement',        to: 'association#announcement',         as: 'announcement'
  match '/newsletter',          to: 'association#newsletter',           as: 'newsletter'
  match '/regulations',         to: 'association#regulations',          as: 'regulations'
    
  match '/add_member/:id',      to: 'membership#add',             as: 'add_member'
  match '/delete_member/:id',   to: 'membership#delete',          as: 'delete_member'
  
  match '/destroy_group/:id',   to: 'groups#destroy',              as: 'destroy_group'
  
  match '/posting_num_pages', to: 'postings#num_pages', as: 'posting_num_pages'
  match '/posting_feed', to: 'postings#feed', as: 'posting_feed'
  
  match '/get_posting_content/:id', to: 'postings#get_content', as: 'get_posting_content'
  match '/get_comment_content/:id', to: 'comments#get_content', as: 'get_comment_content'
  
  match '/get_comments', to: 'comments#get_comments', as: 'get_comments'
  
  match '/like', to: 'likes#create', as: 'like'
  match '/dislike', to: 'likes#destroy', as: 'dislike'
  match '/get_likes', to: 'likes#get_likes', as: 'get_likes'
  
  match '/get_form', to: 'settings#get_form', as: 'get_form'
  match '/get_add_education_form', to: 'settings#get_add_education_form',   as: 'get_add_education_form'
  match '/get_add_employment_form', to: 'settings#get_add_employment_form', as: 'get_add_employment_form'
  match '/update_settings', to: 'settings#update', as: 'update_settings'
  
  match '/destroy_education/:id', to: 'educations#destroy', as: 'destroy_education'
  match '/destroy_employment/:id', to: 'employments#destroy', as: 'destroy_employment'
  
  match '/network',             to: 'network#index',              as: 'network'
  match '/network_school',      to: 'network#school',              as: 'network_school'
  match '/network_organization',to: 'network#organization',        as: 'network_organization'
  match '/profile/:id',       to: 'network#profile',          as: 'profile'
  match '/get_add_tag_form', to: 'network#get_add_tag_form', as: 'get_add_tag_form'

  match '/search_alumni',       to: 'network#search_alumni',             as: 'search_alumni'
  match '/search_school/:id',   to: 'network#search_school',             as: 'search_school'
  match '/search_organization/:id',   to: 'network#search_organization',             as: 'search_organization'
  
  match '/careers', to: 'careers#index', as: 'careers'
  match '/careernotes', to: 'careers#notes', as: 'careernotes'
  match '/alumni_careernotes/:id', to: 'careers#show_notes', as: 'alumni_careernotes'
  match '/write_careernote/:id', to: 'careers#write_note', as: 'write_careernote'
  match '/show_careernote/:id', to: 'careers#show_note', as: 'show_careernote'
  match '/submit_careernote/:id', to: 'careers#submit_note', as: 'submit_careernote'
  match '/create_careernote/:id', to: 'careers#create_note', as: 'create_careernote'
  match '/update_careernote/:id', to: 'careers#update_note', as: 'update_careernote'
  match '/destroy_careernote/:id', to: 'careers#destroy_note', as: 'destroy_careernote'
  match '/get_careernote_form/:id', to: 'careers#get_note_form', as: 'get_careernote_form'
  match '/careernote_num_pages', to: 'careers#notes_num_pages', as: 'careernote_num_pages'
  match '/careernote_feed', to: 'careers#notes_feed', as: 'careernote_feed'
  
  
  
  
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

