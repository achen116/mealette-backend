Rails.application.routes.draw do
  get '/api', to: 'api#index'
  get '/geocode', to: 'geocode#index'
end
