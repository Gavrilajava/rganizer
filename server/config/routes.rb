Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get '/postings', to: "postings#index"
  get '/applied_postings', to: "postings#applied"
  patch '/posting/:id', to: "postings#update"
end
