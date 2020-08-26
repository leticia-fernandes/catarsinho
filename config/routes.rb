Rails.application.routes.draw do
  devise_for :users

  authenticated :user do
    root 'projects#find', as: :authenticated_root
  end

  resources :projects do
    collection do
      get :find
    end
  end

  root 'home#index', as: 'home_index'

end
