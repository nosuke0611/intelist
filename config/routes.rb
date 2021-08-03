Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords'
  }
  
  root 'basic#home'
  get '/following_posts', to: 'basic#followingtl'
  get '/all_posts', to: 'basic#alltl'

  resources :users, only: %i(index show) do
    member do
      get :relationships, :following, :followers
      get :myposts, :favposts, :composts
      get :myitems
    end
  end
  resources :relationships, only: %i(create destroy)
  
  resources :items, only: %i(create destroy index show)
  get '/ranking', to: 'items#weekly_ranking'
  get '/monthly_ranking', to: 'items#monthly_ranking'
  get '/all_ranking', to: 'items#all_ranking'

  resources :posts, except: %i(index new) do
    post :complete, :uncomplete
    resources :likes, only: %i(create destroy)
    resources :comments, only: %i(create destroy)
  end

  # ゲストログイン用ルーティング
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end
end
