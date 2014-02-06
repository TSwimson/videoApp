VideoApp::Application.routes.draw do
  root to: 'videos#index'
  get "users/new", to: 'users#new', as: :signup
  post "/sessions", to: 'sessions#create', as: :sessions
  post '/users', to: 'users#create'
  delete '/sessions', to: 'sessions#destroy', as: :signout

  resources :videos, only: [:index, :create, :destroy, :show, :update]

  delete '/videos/:id/:delete_key', to: "videos#destroy", as: :delete_video_with_key

  get '/users/:id', to: 'users#show', as: :show_user

  get '/videos/:id/d/:delete_key', to: 'videos#delete_page', as: :delete_video_page

  get '/new', to: 'videos#new_new'

  post '/hw/uploaded/:id', to: 'videos#index'
  post '/hw/encoded/:id', to: 'videos#index'

  get '/hw/uploaded/:id', to: 'my_heywatch#upload_complete'
  get '/hw/encoded/:id', to: 'my_heywatch#encode_complete'
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
