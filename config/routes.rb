Rails.application.routes.draw do
  devise_for :users
  root to: 'homes#top'
  resources :users,only: [:show, :edit, :update] do
    collection do
      get :favorites
    end
  end


  resources :posts,only: [:create, :index, :show, :update, :destroy] do
    resource :favorites, only: [:create, :destroy]
    resources :post_comments, only: [:create, :destroy]
  end

end