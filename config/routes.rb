Rails.application.routes.draw do
    root 'articles#index'
    resources :articles, only: [:create, :new, :show]
end
