class StaticPagesController < ApplicationController
   def home
      if signed_in?
         @user = current_user
      end
   end

   def help
   end

   def about
   end

   def contact
   end
end
