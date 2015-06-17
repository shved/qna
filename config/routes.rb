Rails.application.routes.draw do
  root 'questions#index'

  concern :votable do
    member do
      patch :vote_up
      patch :vote_down
      patch :unvote
    end
  end

  resources :questions, concerns: :votable do
    resources :comments, only: :create, defaults: { commentable: 'question' }
    resources :answers, concerns: :votable do
      resources :comments, only: :create, defaults: { commentable: 'answer' }
      patch :mark_best, on: :member
    end
  end

  resources :attachments, only: :destroy

  devise_for :users
end
