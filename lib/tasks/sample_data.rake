namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    #populate admin
    admin=User.create!(name: "essolsoj",
                 email: "jsolsonapallares@gmail.com",
                 password: "Avispao",
                 password_confirmation: "Avispao")
    admin.toggle!(:admin)
    
    #populate users
    99.times do |n|
      name  = Faker::Name.name
      email = "example-#{n+1}@railstutorial.org"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end

    #populate microposts
    users = User.all(limit: 6)
    50.times do
      content = Faker::Lorem.sentence(5) #get a random sentence of at least 5 words
      users.each { |user| user.microposts.create!(content: content) } 
    end
  end
end