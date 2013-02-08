namespace :db do
   desc "Fill database with sample data"
   task populate: :environment do

      admin = User.create!(name: "Chris Morgan",
         email: "thecapn.morgan@gmail.com",
         password: "password",
         password_confirmation: "password"
      )
      admin.toggle!(:admin)
      3.times do |n|
         name  = Faker::Name.name
         email = "example-#{n+1}@thechrismorgan.com"
         password  = "password"
         User.create!(
            name:     name,
            email:    email,
            password: password,
            password_confirmation: password
         )
      end

      users = User.all
      5.times do
         name = Faker::Lorem.sentence(5)
         users.each { |user| user.tasks.create!(name:name, parent_id:0, sort_order:0) }
      end

      admin.tasks.create!(name:"Child1", parent_id:7, sort_order:2)
      admin.tasks.create!(name:"Child2", parent_id:7, sort_order:1)

   end
end
