Mnygo::Application.routes.draw do

  resources :inventory_details
  resources :inventories
  resources :payment_methods

  resources :orders do 
    collection { post :payment  }
    collection { post :imprimir }        
    collection { post :pagar }        
  end 

  resources :stores  do 
    collection { post :search }    
  end 


  resources :carts
  get 'store/index'

  resources :line_items

  resources :carts


  devise_for :users, :controllers => { 
    register: 'new_user_registration' ,
    logout: 'destroy_user_session',
    login: 'user_session'
  }

  
  devise_scope :user  do 
        match '/sessions/user', to: 'devise/sessions#create', via: :post
  end  
  resources :company_user do
    collection { post :new_company_use }
  end 
  
  resources :products   do
    collection { post :import }
    collection { get :search }
    get :who_bought, on: :member
  end 
  resources :products_categories   do
    collection { post :import }
  end 

  # Reports
  match 'companies/reports/monthly_profits/:company_id' => 'reports#monthly_profits', via: [:get, :post]
  match 'companies/reports/profits/:company_id' => 'reports#profits' , via: [:get, :post]
  match 'companies/reports/view_monthly_divisions/:company_id/:division_id' => 'reports#report_view_monthly_divisions', via: [:get, :post]
  match 'companies/reports/monthly_divisions/:company_id' => 'reports#report_monthly_divisions', via: [:get, :post]
  match 'companies/reports/divisions/:company_id' => 'reports#report_divisions', via: [:get, :post]
  match 'companies/reports/view_monthly_locations/:company_id/:location_id' => 'reports#report_view_monthly_locations', via: [:get, :post]
  match 'companies/reports/monthly_locations/:company_id' => 'reports#report_monthly_locations', via: [:get, :post]
  match 'companies/reports/locations/:company_id' => 'reports#report_locations', via: [:get, :post]
  match 'companies/reports/view_monthly_customers/:company_id/:customer_id' => 'reports#report_view_monthly_customers', via: [:get, :post]
  match 'companies/reports/monthly_customers/:company_id' => 'reports#report_monthly_customers', via: [:get, :post]
  match 'companies/reports/customers/:company_id' => 'reports#report_customers', via: [:get, :post]
  match 'companies/reports/view_monthly_products/:company_id/:product_id' => 'reports#report_view_monthly_products', via: [:get, :post]
  match 'companies/reports/monthly_products/:company_id' => 'reports#report_monthly_products', via: [:get, :post]
  match 'companies/reports/products/:company_id' => 'reports#report_products', via: [:get, :post]
  match 'companies/reports/view_monthly_sellers/:company_id/:user_id' => 'reports#report_view_monthly_sellers', via: [:get, :post]
  match 'companies/reports/monthly_sellers/:company_id' => 'reports#report_monthly_sellers', via: [:get, :post]
  match 'companies/reports/sellers/:company_id' => 'reports#report_sellers', via: [:get, :post]
  match 'companies/reports/monthly_sales/:company_id' => 'reports#report_monthly_sales', via: [:get, :post]
  match 'companies/reports/sales/:company_id' => 'reports#report_sales', via: [:get, :post]
  match 'companies/reports/:company_id' => 'reports#reports', via: [:get, :post]

  # Company users

  match 'company_users/ac_users' => 'company_users#ac_users', via: [:get, :post]
  match 'new_company_use', to: 'company_users#new', via: [:get]
  match 'company_list', to: 'company_users#list_users', via: [:get, :post] 
  resources :company_users

  # Invoices
  match 'invoice/add_kit/:company_id' => 'invoices#add_kit', via: [:get, :post]
  match 'invoices/list_items/:company_id' => 'invoices#list_items', via: [:get, :post]
  match 'invoices/ac_kit/:company_id' => 'invoices#ac_kit', via: [:get, :post]
  match 'invoices/ac_products/:company_id' => 'invoices#ac_products', via: [:get, :post]
  match 'invoices/ac_user/:company_id' => 'invoices#ac_user', via: [:get, :post]
  match 'invoices/ac_customers/:company_id' => 'invoices#ac_customers', via: [:get, :post]
  match 'invoices/new/:company_id' => 'invoices#new', via: [:get, :post]
  

  match 'invoices/do_email/:id' => 'invoices#do_email', via: [:get, :post]
  match 'invoices/do_process/:id' => 'invoices#do_process', via: [:get, :post]
  match 'invoices/email/:id' => 'invoices#email', via: [:get, :post]
  match 'invoices/pdf/:id' => 'invoices#pdf', via: [:get, :post]
  match 'companies/invoices/:company_id' => 'invoices#list_invoices', via: [:get, :post]
  resources :invoices

  # Customers
  match 'customers/create_ajax/:company_id' => 'customers#create_ajax', via: [:get, :post]
  match 'customers/new/:company_id' => 'customers#new', via: [:get, :post]
  match 'companies/customers/:company_id' => 'customers#list_customers', via: [:get, :post]
  resources :customers

  # Divisions
  match 'divisions/new/:company_id' => 'divisions#new', via: [:get, :post]
  match 'companies/divisions/:company_id' => 'divisions#list_divisions', via: [:get, :post]
  resources :divisions

  # Restocks
  match 'restocks/process/:id' => 'restocks#do_process', via: [:get, :post]
  match 'restocks/new/:company_id/:product_id' => 'restocks#new', via: [:get, :post]
  match 'companies/restocks/:company_id/:product_id' => 'restocks#list_restocks', via: [:get, :post]
  resources :restocks

  # Products kits
  match 'products_kits/list_items/:company_id' => 'products_kits#list_items', via: [:get, :post]
  match 'products_kits/new/:company_id' => 'products_kits#new', via: [:get, :post]
  match 'companies/products_kits/:company_id' => 'products_kits#list_products_kits', via: [:get, :post]
  resources :products_kits

  # Products Categories

  match 'products_categories/new/:company_id' => 'products_categories#new', via: [:get, :post]
  match 'companies/products_categories/:company_id' => 'products_categories#list_products_categories', via: [:get, :post]
  resources :products_categories

  # Products
  match 'products/ac_products/:company_id' => 'products#ac_products', via: [:get, :post]
  match 'products/ac_categories/:company_id' => 'products#ac_categories', via: [:get, :post]
  match 'products/new/:company_id' => 'products#new', via: [:get, :post]
   match 'companies/products/:company_id' => 'products#list_products', via: [:get, :post]
  resources :products

  # Suppliers
  match 'suppliers/new/:company_id' => 'suppliers#new', via: [:get, :post]
  match 'companies/suppliers/:company_id' => 'suppliers#list_suppliers', via: [:get, :post]
  resources :suppliers

  # Locations
  match 'locations/new/:company_id' => 'locations#new', via: [:get, :post]
  match 'companies/locations/:company_id' => 'locations#list_locations', via: [:get, :post]
  resources :locations
  
  # Companies
  match 'companies/export/:id' => 'companies#export', via: [:get, :post]
  match 'new_company', to: 'companies#new', via: [:get]
  #match "register" => 'devise/registrations/' , via: [:get, :post]
  resources :companies

  # Users packages
  resources :users_packages

  # Packages
  match 'payment/:slug' => 'packages#payment', via: [:get, :post]
  match 'pricing/:slug' => 'packages#pick_package', via: [:get, :post]
  match 'pricing' => 'packages#pricing', via: [:get, :post]
  resources :packages

  # Pages
  match 'p/:page_name' => 'pages#name_clean', via: [:get, :post]
  match 'dashboard' => 'pages#dashboard', via: [:get, :post]
  match 'err_not_found' => 'pages#err_not_found', via: [:get, :post]
  match 'quick_upload' => 'pages#quick_upload', via: [:get, :post]
  resources :pages

  # Users
  match 'err_perms' => 'users#err_perms', via: [:get, :post]
  match "register" => 'devise/registrations#new' , via: [:get, :post]
  match 'logout' => 'devise/sessions#destroy', via: [:get, :post]
  match 'login' => 'devise/sessions#new', via: [:get, :post]
  resources :users
  
  #Orders
  #match 'store/index/:company_id' => 'store#index', via: [:get, :post]
  match 'companies/stores/:company_id' => 'stores#index', via: [:get, :post]
  resources :stores

  match 'orders/pdf/:id' => 'orders#pdf', via: [:get, :post]  
  match 'orders/new/:company_id' => 'orders#new', via: [:get, :post]
  match "pagar" => "orders#new" , via: [:get]
  resources :orders

  match 'companies/inventories/:company_id' => 'inventories#list_inventories', via: [:get, :post]
  resources :invoices


  # Sessions
  resources :sessions
  
  # Frontpage
 # match 'dashboard' => 'pages#dashboard', via: [:get,s :post]

  root :to => "pages#frontpage"
  
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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
