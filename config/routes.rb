Rails.application.routes.draw do
  root 'questions#index'

  devise_for :users

  resources :attachments, only: :destroy

  resources :questions do
    resources :answers do
      patch :vote, on: :member
      patch :mark_best, on: :member
    end
  end
end
