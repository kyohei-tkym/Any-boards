Rails.application.routes.draw do
  devise_for :users
  root to: 'homes#top'
  resources :users,only: [:show, :edit, :update] do
    collection do
      get :favorites
    end
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end


  resources :posts,only: [:create, :index, :show, :update, :destroy] do
    resource :favorites, only: [:create, :destroy]
    resources :post_comments, only: [:create, :destroy]
  end

  get '/search' => 'search#search'
end