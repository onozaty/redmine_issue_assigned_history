# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
    get 'issue_assigned_histories.:format', :to => 'issue_assigned_histories#index'
end
