SublimeVideoCustomLogsParsing::Application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web, at: '/sidekiq'

  resources :daily_views_per_countries, only: [:index]

  root to: 'daily_views_per_countries#index'
end
