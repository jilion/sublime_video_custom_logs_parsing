SublimeVideoCustomLogsParsing::Application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web, at: '/sidekiq'

  resources :monthly_views, only: [:index] do
    collection do
      get :country
      get :region
    end
  end

  root to: redirect('/monthly_views')
end
