Railscasts::Application.routes.draw do
 
  root :to => "episodes#index"

  match "auth/:provider/callback" => "users#create"
  match "about" => "info#about", :as => "about"
  match "give_back" => "info#give_back", :as => "give_back"
  match "moderators" => "info#moderators", :as => "moderators"
  match "login" => "users#login", :as => "login"
  match "logout" => "users#logout", :as => "logout"
  match "feedback" => "feedback_messages#new", :as => "feedback"
  match "episodes/archive" => redirect("/?view=list")
  match 'unsubscribe/:token' => 'users#unsubscribe', :as => "unsubscribe"
  post "versions/:id/revert" => "versions#revert", :as => "revert_version"

  # Users
  resource :users do 
    # TODO put into a member block 
    member { put :ban } 
    match "profile/:id" => "users#show", :on => :member, :as => :profile       
  end 
  devise_for :users 
  
  resources :comments
  resources :episodes
  resources :feedback_messages

  match "tags/:id" => redirect("/?tag_id=%{id}")
end
