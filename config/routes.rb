Lab::Application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'

  resources :lab_cats


  resources :lab_notices


  resources :lab_seats


  resources :lab_question_items


  resources :lab_questions


  resources :lab_reports


  resources :lab_equipments


  resources :lab_scene_resources


  resources :lab_scenes


  resources :lab_suppliers


  resources :lab_devices


  resources :lab_device_supports


  resources :lab_course_students


  resources :lab_coursewares


  resources :lab_courses


  resources :lab_eval_projects


  resources :lab_permissions_roles


  resources :lab_permissions


  resources :lab_roles

  mount Ckeditor::Engine => "/ckeditor"


  resources :lab_users do
    get :login,:on=>:collection
    post :login_in,:on=>:collection
    get :logout,:on=>:collection
    get :teacher_manage,:on=>:collection
    get :apply_manage,:on=>:collection
    get :admin_manage,:on=>:collection
    get :lab_manage,:on=>:collection
    get :student_manage,:on=>:collection
    get :system_manage,:on=>:collection
    get :home,:on=>:collection
  end

  root :to => "lab_users#home"
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
