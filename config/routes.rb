Rails.application.routes.draw do
  root "games#new"
  
  get "new", to: "games#new"
  get "score", to: "games#score"
  post "score", to: "games#score"
end
