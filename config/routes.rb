SublimeVideoCustomLogsParsing::Application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web, at: '/sidekiq'

  root to: redirect('/sidekiq')
end
