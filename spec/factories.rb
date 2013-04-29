#FactoryGirl.define do
 # factory :user do
 #   name     "Michael Hartl"
 #   email    "michael@example.com"
 #   password "foobar"
 #   password_confirmation "foobar"
 # end
#end

FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com"}   
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end


#use FactoryGirl.create(:admin) to create an administrative user in our tests.

  factory :micropost do
    content "Lorem ipsum"
    user
  end
end
#we tell factory girl that micropost has a belongs_to dependency just by adding user
#this allows us to define factory microposts as follows:
#FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)

