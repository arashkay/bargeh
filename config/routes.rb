Rails.application.routes.draw do
 
  devise_for :admins
  root 'panel/general#index'
   
  namespace :panel do
    get 'api' => 'general#api'
    get 'charts' => 'general#charts'
    resources :users, only: [:index]
    resources :flags, only: [:index, :destroy] do
      member do
        post :clean
      end
    end
  end

  scope :api, defaults: { format: 'json' } do
    scope :v1, :version => 'v1' do
      post '/authenticate' => 'users#authenticate'
      resources :me, controller: :users, only: [] do
        collection do
          post '', action: :create
          get  '', action: :me
          put  '', action: :update
        end
      end
      scope :me do
        post '/conversations/:id/viewed' => 'messages#conversation_viewed'
        resources :conversations, controller: :messages, only:[] do
          collection do
            get '', action: :conversations
          end
        end
        get '/messages/:with_user_id' => 'messages#messages'
        resources :messages, only:[] do
          collection do
            post '', action: :create
            post :viewed 
          end
        end
        resources :posts, only:[:create, :update, :destroy]
        resources :comments, only:[:create, :destroy]
      end
      resources :posts, only:[:index, :show]
      resources :users, only:[:show] do
        member do
          post :flagged
        end
      end
      resources :notifications, only:[] do
        collection do
          post :mock
        end
      end
    end
  end

 
end
