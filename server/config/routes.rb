Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '/postings', to: "postings#index"
  get '/applied_postings', to: "postings#applied"
  patch '/posting/:id', to: "postings#update"

  get '/keywords', to: "keywords#index"
  post '/keywords', to: "keywords#create"
  patch '/keywords/:id', to: "keywords#update"
  delete '/keywords/:id', to: "keywords#destroy"

  get '/locations', to: "locations#index"
  post '/locations', to: "locations#create"
  patch '/locations/:id', to: "locations#update"
  delete '/locations/:id', to: "locations#destroy"

end
