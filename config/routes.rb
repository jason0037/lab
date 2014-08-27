Lab::Application.routes.draw do

  resources :lab_mobile_courses do
    post :search , :on=>:member
  end


  resources :lab_teach_resources do
    post :search , :on=>:member
  end



  resources :lab_teach_designs do
    post :search , :on=>:member
  end

  match ':controller(/:action(/:id))', :controller => /fusioncharts\/[^\/]+/

  resources :options do
    post :search , :on=>:member
  end

  resources :monitors do
    get :receive_data , :on=>:collection
    get :lab_comprehensive,:on=>:collection
    get :online_comprehensive,:on=>:collection
    get :comprehensive_data,:on=>:collection
    get :dashboard_data,:on=>:collection
    get :energy_consumption,:on=>:collection
    get :energy_consumption_data,:on=>:collection
    get :mind_wave, :on=>:collection
    get :mind_wave_data, :on=>:collection
    get :mindwave_data_history, :on=> :collection
    get :behaviour, :on=> :collection
    get :behaviour_data, :on=> :collection
    get :behaviour_data_history, :on=> :collection
    get :network, :on=> :collection
    get :network_data, :on=> :collection
    get :get_big_chart, :on=> :collection
    get :general_behaviour, :on=> :collection
    get :general_behaviour_data, :on=> :collection
    get :online, :on=> :collection
    get :course_study, :on=> :collection
    get :course_study_data, :on=> :collection
    get :interactive_study, :on=> :collection
    get :interactive_study_data, :on=> :collection
    get :get_realtime_data, :on=> :collection
    get :history,:on=>:collection
  end


  mount Ckeditor::Engine => '/ckeditor'

  resources :lab_cats do
    post :search , :on=>:member
  end


  resources :lab_notices do
    post :search , :on=>:member
  end


  resources :lab_seats do
    post :search , :on=>:member
  end

  resources :lab_questions_scores do
    post :search , :on=>:member
  end
  resources :lab_questions
  resources :lab_questionnaires do
    post :search , :on=>:member
    get :status , :on=>:member

    resources :lab_questions do
      post :search , :on=>:member
    end
  end

  resources :lab_reports do
    get :export_excel , :on=>:member
  end


  resources :lab_equipments


  resources :lab_scene_resources do
    post :search , :on=>:member
  end


  resources :lab_scenes do
    post :search , :on=>:member
  end


  resources :lab_suppliers do
    post :search , :on=>:member
  end


  resources :lab_devices do
    get :app_query,:on=>:collection
    post :app_save,:on=>:collection
    post :search , :on=>:member
  end


  resources :lab_device_supports do
    post :search , :on=>:member
  end

  resources :lab_course_students do
    post :search , :on=>:member
  end


  resources :lab_coursewares do
    post :search , :on=>:member
  end

  resources :lab_reports do
    get :export,:on=>:member
    post :search , :on=>:member
  end


  resources :lab_courses do
    resources :monitors do
      get :history, :on=> :collection
    end
    get :learn,:on=>:collection
    get :teach,:on=>:collection
    post :search , :on=>:member
    get :status , :on=>:collection
    get :ready, :on =>:member
  end

  resources :lab_courses do
    member do
      get 'grand'
      get 'opinion'
    end
  end

  resources :lab_eval_projects do

    resources :lab_questions_scores
    resources :lab_courses

    member do
      get 'approve'
      get 'reject'
      get 'submit_apply'
      post 'search'
    end

    get :apply,:on=>:collection

  end


  resources :lab_permissions_roles do
    post :search , :on=>:member
  end


  resources :lab_permissions do
    post :search , :on=>:member
  end


  resources :lab_roles do
    post :search , :on=>:member
  end

  mount Ckeditor::Engine => "/ckeditor"

  resources :lab_users do
    get :login,:on=>:collection
    get :forgot_pass,:on=>:collection
    get :reset_pass,:on=>:member
    post :modify_pass,:on=>:collection
    post :pass_change,:on=>:collection
    post :login_in,:on=>:collection
    get :logout,:on=>:collection
    get :teacher_manage,:on=>:collection
    get :apply_manage,:on=>:collection
    get :course_manage,:on=>:collection
    get :lab_manage,:on=>:collection
    get :student_manage,:on=>:collection
    get :system_manage,:on=>:collection
    get :home,:on=>:collection
    get :query,:on=>:collection
    get :pass,:on=>:member
    post :search , :on=>:member
  end

  resources :app_tests do
    collection do
      get :register
      post :login
      post :updateUserInfo
      get :getUserInfo
      post :saveTestScore
      get :getTestScore
      post :saveGameScore
      get :getGameScore
      get :getTestHist
      get :changePwd
    end

    post :search , :on=>:member
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
