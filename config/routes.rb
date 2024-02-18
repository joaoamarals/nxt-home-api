Rails.application.routes.draw do
  mount GoodJob::Engine => 'good_job'
  resources :searches, only: :create
end
