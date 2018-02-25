Rails.application.routes.draw do
  devise_for :users
  root 'questions#index'

  resources :questions, shallow: true do
    post :vote_for, on: :member
    post :vote_against, on: :member
    
    resources :answers, only: %i[destroy create update] do
      post :best_answer, on: :member
      # resources :votes, only: :update
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
