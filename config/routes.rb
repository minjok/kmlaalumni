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
    resources :tags
  end
  
  resources :comments
  
  resources :educations
  
  resources :employments do
    resources :careernotes
  end
  
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
  match '/profile/:id',       to: 'network#profile',          as: 'profile'
  match '/get_add_tag_form', to: 'network#get_add_tag_form', as: 'get_add_tag_form'

  match '/search_alumni',       to: 'network#search_alumni',             as: 'search_alumni'
  match '/search_school/:id',   to: 'network#search_school',             as: 'search_school'
  
  match '/organizations', to: 'careers#show_organization', as: 'organizations'
  match '/search_organization/:id', to: 'careers#search_organization', as: 'search_organization'
  
  match '/careernote_dashboard', to: 'careernotes#dashboard', as: 'careernote_dashboard'
  match '/new_careernote', to: 'careernotes#new', as: 'new_careernote'
  match '/edit_careernote/:id', to: 'careernotes#edit', as: 'edit_careernote'
  match '/careernote_num_pages', to: 'careernotes#num_pages', as: 'careernote_num_pages'
  match '/careernote_feed', to: 'careernotes#feed', as: 'careernote_feed'
  match '/get_careernote_content/:id', to: 'careernotes#get_content', as: 'get_careernote_content'
 
  match '/add_tag_button', to:'tags#add_tag_button', as:'add_tag_button'
  match '/add_tag', to:'tags#add_tag', as:'add_tag'

end

