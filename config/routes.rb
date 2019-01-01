Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  post 'readings', to: 'readings#create'
  get 'readings/:id', to: 'readings#show'
  get 'stats', to: 'stats#index'
end
