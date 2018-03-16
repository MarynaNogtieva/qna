Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  root 'questions#index'

  concern :votes do
    post :vote_for, on: :member
    post :vote_against, on: :member
    post :reset_vote, on: :member
  end

  concern :comments do
    resources :comments,  only: [:create]
  end

  resources :questions, shallow: true, concerns: [:votes, :comments]  do
    resources :answers, only: %i[destroy create update], concerns: [:votes, :comments] do
      post :best_answer, on: :member
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  # setup connection with the server
  mount ActionCable.server => '/cable'
end
