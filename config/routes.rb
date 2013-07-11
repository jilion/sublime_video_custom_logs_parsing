SublimeVideoCustomLogsParsing::Application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web, at: '/sidekiq'

  get 'views/per/country' => 'monthly_views#country', as: 'monthly_views_per_country'
  get 'views/per/region' => 'monthly_views#region', as: 'monthly_views_per_region'

  root to: redirect('/views/per/country')
end
