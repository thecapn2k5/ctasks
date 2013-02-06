Ctasks::Application.routes.draw do
   resources :users
   resources :sessions, only: [:new, :create, :destroy]
   resources :tasks

   root to: 'static_pages#home'

   match '/signup',   to: 'users#new'
   match '/signin',   to: 'sessions#new'
   match '/signout',  to: 'sessions#destroy', via: :delete

   match '/help',     to: 'static_pages#help'
   match '/about',    to: 'static_pages#about'
   match '/contact',  to: 'static_pages#contact'

   match '/toggle_hide_task', to: 'tasks#toggle_hide_task'
   match '/save_task_sort', to: 'tasks#save_task_sort'
   match '/change_task_name', to: 'tasks#change_task_name'
   match '/add_task', to: 'tasks#add_task'
   match '/destroy_task', to: 'tasks#destroy_task'

   # Sample of regular route:
   #   match 'products/:id' => 'catalog#view'

   # Sample of named route:
   #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
   # This route can be invoked with purchase_url(:id => product.id)

   # Sample resource route (maps HTTP verbs to controller actions automatically):
   #   resources :products

   # You can have the root of your site routed with "root"
   # just remember to delete public/index.html.
   # root :to => 'welcome#index'

   # See how all your routes lay out with "rake routes"
end
