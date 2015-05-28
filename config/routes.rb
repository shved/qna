Rails.application.routes.draw do
  root 'questions#index'

  concern :votable do
    member do
      patch :vote_up
      patch :vote_down
      patch :unvote
    end
  end

  concern :commentable do
    resource :comments, only: :create
  end

  resources :questions, concerns: [:votable, :commentable] do
    resources :answers, concerns: [:votable, :commentable] do
      patch :mark_best, on: :member
    end
  end

  resources :attachments, only: :destroy

  devise_for :users
end
