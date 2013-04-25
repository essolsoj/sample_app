require 'spec_helper'

describe "User pages" do
  #create a user with FactoryGirl
  subject { page }

  describe "signup page" do
    before { visit signup_path } #user_path created autom. in routes.rb

    it { should have_selector('h1',    text: 'Sign up') }
    it { should have_selector('title', text: full_title('Sign up')) }

    describe "signup" do
      let(:submit) { "Create my account" }

      describe "with invalid information" do
        it "should not create a user" do
          # evaluates User.count before and after execution of block
          expect { click_button submit }.not_to change(User, :count)
        end

        describe "after submission" do
          before { click_button submit }

          it { should have_selector('title', text: 'Sign up') }
          it { should have_content('error') }
        end
      end 

      describe "with valid information" do
        before do
          fill_in "Name",         with: "Example User"
          fill_in "Email",        with: "user@example.com"
          fill_in "Password",     with: "foobar"
          fill_in "Confirmation", with: "foobar"
        end
        it "should create a user" do
          expect { click_button submit }.to change(User, :count).by(1)
        end 
        describe "after saving the user" do
          before { click_button submit }
          let(:user) { User.find_by_email('user@example.com') }

          it { should have_selector('title', text: user.name) }
          it { should have_selector('div.alert.alert-success', text: 'Welcome') }
        end
      end
    end
  end
  
  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user #edit is protected by signim
      visit edit_user_path(user) 
    end

    describe "page" do
      it { should have_selector('h1',    text: "Update your profile") }
      it { should have_selector('title', text: "Edit user") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end

      it { should have_selector('title', text: new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { user.reload.name.should  == new_name } #reload new user from database
      specify { user.reload.email.should == new_email }
    end
  end

  describe "profile page" do
  	let(:user) { FactoryGirl.create(:user) } #creates user variable
    #let (:user) {User.create name: “jordi”, email:”solso”, password:”foobar”, password_confirmation:”foobar”}
    before { visit user_path(user) }

    it { should have_selector('h1',    text: user.name) }
    it { should have_selector('title', text: user.name) }
  end

  describe "index" do
    before do
      sign_in FactoryGirl.create(:user) #index is protected via signin
      FactoryGirl.create(:user, name: "Bob", email: "bob@example.com")
      FactoryGirl.create(:user, name: "Ben", email: "ben@example.com")
      visit users_path
    end

    it { should have_selector('title', text: 'All users') }
    it { should have_selector('h1',    text: 'All users') }

    describe "pagination" do
      #create 30 users
      before(:all) { 30.times { FactoryGirl.create(:user) } }
      #delet all users
      after(:all)  { User.delete_all }

      it { should have_selector('div.pagination') }
      #check all the list items in page 1
      it "should list each user" do
        User.paginate(page: 1).each do |user|
          page.should have_selector('li', text: user.name)
        end
      end
    end
  
    describe "delete links" do
      # non-admin users cannot delete
      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
          
          User.paginate(page: 1).each do |user|
              @nonadmin = user
              if !user.admin? then break end
          end
        end

        it { should have_link('delete', href: user_path(@nonadmin)) }
        it "should be able to delete another user" do
          expect { click_link('delete') }.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end
  end
end