namespace :db do
   desc "Fill database with sample data"
   task populate: :environment do

      admin = User.create!(name: "Chris Morgan",
         email: "thecapn.morgan@gmail.com",
         password: "password",
         password_confirmation: "password"
      )
      admin.toggle!(:admin)
      user.toggle!(:admin)
      99.times do |n|
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
   end
end
