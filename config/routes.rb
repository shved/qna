Rails.application.routes.draw do
  root 'questions#index'

  devise_for :users

  resources :questions do
    resources :answers do
      patch :vote, on: :member
    end
  end
end
