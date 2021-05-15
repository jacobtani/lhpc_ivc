Rails.application.routes.draw do
    devise_for :users, only: [:sessions, :passwords, :registrations], :controllers => { :sessions => "admin/sessions", passwords: "admin/passwords", registrations: "admin/registrations" }
end
