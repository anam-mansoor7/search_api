Rails.application.routes.draw do
  resources :search, only: :pages do
    get :pages, on: :collection
    get :pages_by_term_count, on: :collection
  end

  resources :search_pages_by_ts_vector, only: :index
end
