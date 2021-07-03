Rails.application.routes.draw do
  devise_for :users
  root 'basic#home'
end
