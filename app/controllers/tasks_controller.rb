class TasksController < ApplicationController
   before_filter :signed_in_user

   def add_task
      task = current_user.tasks.new()
      task.name = params[:name]
      task.parent_id = params[:parent_id]
      task.sort_order = 0
      task.save

      task_string = "{\"name\":\"#{task.name}\", \"id\":\"#{task.id}\", \"parent_id\":\"#{task.parent_id}\"}"
      render text: task_string, content_type: "application/json"
   end

   def destroy_task
      task = get_task_if_user(params[:id])
      if task.parent_id == 0
         parent = current_user
      else
         parent = get_task_if_user(task.parent_id)
      end
      destroy_dependent_tasks(task)

      task_string = "{\"id\":\"#{task.id}\", \"any\":\"#{parent.tasks.any?}\", \"parent_id\":\"#{task.parent_id}\", \"taskscount\":\"#{current_user.tasks.count}\"}"
      render text: task_string, content_type: "application/json"
   end

   def toggle_hide_task
      task = get_task_if_user(params[:id])
      if task.hidden
         task.hidden = false
      else
         task.hidden = true
      end
      task.save
      render text: task.id, content_type: "application/json"
   end

   def change_task_name
      task = get_task_if_user(params[:id])
      task.name = params[:name]
      task.save

      render text: "success!", content_type: "text/html"
   end

   def save_task_sort
      if params[:tasks]
         ids = params[:tasks].split(',')

         ids.each do | id |
            task = get_task_if_user(id)
            task.sort_order = ids.find_index(id)
            task.save
         end

         render text: "success!", content_type: "text/html"
      else
         render text: "no tasks?", content_type: "text/html"
      end

   end

   private
      def get_task_if_user(task_id)
         task = Task.find(task_id)
         user = User.find(task.user_id)

         redirect_to(root_path) unless current_user?(user)

         task
      end

      def destroy_dependent_tasks(task)
         if task.tasks.any?
            task.tasks.each do |task|
               destroy_dependent_tasks(task)
            end
         end
         task.destroy

      end

end
