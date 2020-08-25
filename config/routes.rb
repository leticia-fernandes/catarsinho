Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
    root 'home#home', as: :authenticated_root
  end

  root 'home#index', as: 'home_index'
end
