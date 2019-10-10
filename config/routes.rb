Rails.application.routes.draw do
  resources :search, only: :pages do
    get :pages, on: :collection
  end
end
