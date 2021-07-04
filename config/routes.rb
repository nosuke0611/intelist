Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    passwords: 'users/passwords'
  }
  root 'basic#home'

  resources :users, only: %i(index show) do
    member do
      get :following, :followers
    end
  end
  resources :relationships, only: %i(create destroy)

  # ゲストログイン用ルーティング
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end
end
