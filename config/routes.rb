Rails.application.routes.draw do
  get 'users/friends'

  namespace :api do
    namespace :v1 do
      get 'snaps', to: 'snaps#index'
      get 'snaps/:id', to: 'snaps#show'
      post 'snaps', to: 'snaps#create'
      put 'snaps/:id/read', to: 'snaps#mark_as_read'

      get 'users/friends', to: 'users#friends'
      post 'users/authenticate', to: 'users#authenticate'
      post 'users/push_notification_tokens', to: 'users#add_push_notification_token'
      post 'media/upload', to: 'media#upload'
    end
  end
end
