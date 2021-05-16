Rails.application.routes.draw do
  root :to => 'application#page_not_found'

  namespace :admin do
    devise_for :users, only: [:sessions, :passwords, :registrations], :controllers => { :sessions => "admin/sessions", passwords: "admin/passwords", registrations: "admin/registrations" }
    resources :users
    resources :members do
      member do
        get 'children'
      end
      resources :invoices
    end
  end
end
