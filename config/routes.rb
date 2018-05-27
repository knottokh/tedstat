Rails.application.routes.draw do
  get 'scores/new'

  get 'scores/edit'

  #get 'teachers/index'

  
  devise_for :users, controllers: {
       registrations: 'users/registrations',
       sessions: 'users/sessions'
  }
  
  devise_scope :user do
    get 'new_teacher', to: 'users/registrations#newteacher'
    get 'edit_teacher', to: 'users/registrations#editteacher'
  end
  
  get '/showapproved' => 'ajaxremotes#showapproved'
  get '/ajaxremotes/showpending'
  get '/showmycourse'  => 'ajaxremotes#showmycourse'
  get '/showgraph' => 'ajaxremotes#showgraph'
  get '/showalertcourse'  => 'ajaxremotes#showalertcourse'
  get '/showgraphemo'  => 'ajaxremotes#showgraphemo'
  
  post '/updatescore' => 'taskresults#createorupdate'
  post '/updatetext' => 'taskresults#createorupdatetext'
  post '/updatepoint' => 'taskresults#createorupdatepoint'
  
  post '/updateorder' => 'scourses#updatestudennumber'
  
  resources :courses  
  
  resources :rooms 

  get '/rooms/:id/editscore', to: 'rooms#editscore', as: 'editscore'
  
  resources :tasks
  resources :scores
  resources :feedbacks
  
  get '/editcourse' => 'courses#edit'
  get '/editroom' => 'rooms#edit'
  #get '/edittask' => 'tasks#edit'
  
  get '/selecttype' => 'pages#show'
  get '/teacher_dashboard' => 'teachers#index'
  post '/teacher_dashboard' => 'teachers#indexpost'
  get '/managecourse' => 'teachers#manage'
  post '/managecourse' => 'teachers#managepost'
  get '/reportcourse' => 'teachers#report'
  post '/reportcourse' => 'teachers#reportpost'
  get '/getapprove' => 'teachers#showapproved'
  post '/approve' => 'teachers#approvepost'
  post '/reject' => 'teachers#rejectpost'
  get '/genmypin' => 'teachers#genmypin'
  get '/printreport' => 'teachers#printreport'
  
  get '/studentinfo' => 'othermodals#infostudent'
  
  get '/student_dashboard' => 'students#index'
  get "/allschools" => 'schools#allschools'
  post "/newrequest" => "students#createrequest"
  post "/addemotion" => "students#addemotion"
  
  get '/adminimport' => 'admin#import'
  post '/adminimport' => 'admin#importpost'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  root "pages#index"
  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
