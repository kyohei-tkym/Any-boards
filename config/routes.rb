Rails.application.routes.draw do
  devise_for :users
  root to: 'homes#top'
  post '/homes/guest_sign_in', to: 'homes#guest_sign_in'

  resources :users,only: [:show, :edit, :update] do
    collection do
      get :favorites
    end
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end


  resources :posts,only: [:create, :index, :show, :update, :destroy, :new, :edit] do
    resource :favorites, only: [:create, :destroy]
    resources :post_comments, only: [:create, :destroy]
  end

  get '/search' => 'search#search'

  get '/rank' => 'ranks#rank'
end