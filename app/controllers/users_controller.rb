class UsersController < ApplicationController
   before_filter :signed_in_user, only: [:index, :show, :edit, :update, :destroy]
   before_filter :correct_user,   only: [:show, :edit, :update]
   before_filter :admin_user,     only: [:show, :index, :destroy]

   def index
      @users = User.paginate(page: params[:page])
   end

   def show
      redirect_to root_path
   end

   def new
      @user = User.new
   end

   def create
      @user = User.new(params[:user])
      if @user.save
         make_default_tasks @user
         sign_in @user
         flash[:success] = "Welcome to cTasks!"
         redirect_to @user
      else
         render "new"
      end
   end

   def edit
   end

   def update
      @user = User.find(params[:id])
      if @user.update_attributes(params[:user])
         flash[:success] = "Profile updated"
         sign_in @user
         redirect_to @user
      else
         render 'edit'
      end
   end

   def destroy
      User.find(params[:id]).destroy
      flash[:success] = "User destroyed."
      redirect_to users_url
   end

   private
      def correct_user
         @user = User.find(params[:id])
         redirect_to(root_path) unless current_user?(@user)
      end

      def admin_user
         redirect_to(root_path) unless current_user.admin?
      end

      def make_default_tasks(user)
         i = 0
         name = "Welcome to cTasks! These are some example tasks to help you learn cTasks."
         task = user.tasks.create(sort_order: i, parent_id: 0, name: name)

         i += 1
         name = "Add a task by clicking the clipboard with the green +."
         task = user.tasks.create(sort_order: i, parent_id: 0, name: name)

         i += 1
         name = "Names can only be 75 characters long."
         task = user.tasks.create(sort_order: i, parent_id: 0, name: name)

         i += 1
         name = "Tasks can have sub-tasks."
         task = user.tasks.create(sort_order: i, parent_id: 0, name: name)

         i += 1
         name = "Look at me! I'm a sub-task!"
         task = user.tasks.create(sort_order: i, parent_id: task.id, name: name)
         temp_save_id = task.id

         i += 1
         name = "Even sub-tasks can have sub-tasks."
         task = user.tasks.create(sort_order: i, parent_id: task.id, name: name)

         i += 1
         name = "Tasks and sub-tasks can have as many sub-tasks as you want."
         task = user.tasks.create(sort_order: i, parent_id: temp_save_id, name: name)

         i += 1
         name = "To create a sub-task, click the add sub-task button to the right."
         task = user.tasks.create(sort_order: i, parent_id: temp_save_id, name: name)

         i += 1
         name = "To delete a task and its sub-tasks, click the delete button to the right."
         task = user.tasks.create(sort_order: i, parent_id: 0, name: name)

         i += 1
         name = "Tasks can be sorted using the blue arrows.  Drag and drop to rearrange."
         task = user.tasks.create(sort_order: i, parent_id: 0, name: name)

         i += 1
         name = "Tasks with sub-tasks can be collapsed using the black arrows to the left."
         task = user.tasks.create(sort_order: i, parent_id: 0, name: name)

         i += 1
         name = "Tasks remember whether they were collapsed next time you come to cTasks."
         task = user.tasks.create(sort_order: i, parent_id: task.id, name: name)

         i += 1
         name = "That's it!  Delete these sample tasks and start enjoying cTasks!"
         task = user.tasks.create(sort_order: i, parent_id: 0, name: name)
      end

end
