Railscasts::Application.routes.draw do
 
  root :to => "episodes#index"

  match "auth/:provider/callback" => "users#create"
  match "about" => "infos#about", :as => "about"
  match "we-buy" => "infos#we_buy", :as => "we_buy"
  match "admin" => "infos#admin", :as => "admin" 
  match "moderators" => "infos#moderators", :as => "moderators"
  match "login" => "users#login", :as => "login"
  match "logout" => "users#logout", :as => "logout"
  match "feedback" => "feedback_messages#new", :as => "feedback"
  match "episodes/archive" => redirect("/?view=list")
  match 'unsubscribe/:token' => 'users#unsubscribe', :as => "unsubscribe"
  post "versions/:id/revert" => "versions#revert", :as => "revert_version"

  devise_for :users 
  
  resources :users do 
    member do 
        put "ban" => "users#ban", :as => :ban        
    end 
  end 
    
  resources :comments
  resources :feedback_messages
  
  resources :episodes do 
    resources :assets     
  end  

  match "tags/:id" => redirect("/?tag_id=%{id}")
  
  match '*a' => 'errors#routing'
end
