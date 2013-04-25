require 'spec_helper'

describe "AuthenticationPages" do
  describe "Authentication" do

    subject { page }
    
    describe "signin page" do
      before { visit signin_path }
    
      it { should have_selector('h1',    text: 'Sign in') }
      it { should have_selector('title', text: 'Sign in') }

      describe "with invalid information" do
        before { click_button "Sign in" }

        it { should have_selector('title', text: 'Sign in') }
        it { should have_selector('div.alert.alert-error', text: 'Invalid') }
      
        describe "after visiting another page" do
          before { click_link "Home" }
          it { should_not have_selector('div.alert.alert-error') }
        end
      end #with invalid info

      describe "with valid information" do
        let(:user) { FactoryGirl.create(:user) }
        before { sign_in user }

        it { should have_selector('title', text: user.name) }
        it { should have_link('Users',    href: users_path) }
        it { should have_link('Profile', href: user_path(user)) }
        it { should have_link('Sign out', href: signout_path) }
        it { should_not have_link('Sign in', href: signin_path) }

        describe "followed by signout" do
          before { click_link "Sign out" }
          it { should have_link('Sign in') }
        end 
      end #with valid info
    end #signin page
    
    describe "authorization" do

      describe "for non-signed-in users" do
        let(:user) { FactoryGirl.create(:user) }
        #user created but not signed in
        describe "in the home page" do
          before { visit root_path }
          it { should_not have_link('Users',    href: users_path) }
          it { should_not have_link('Profile',  href: user_path(user)) }
        end
          
        describe "in the Users controller" do
          describe "visiting the edit page" do
            before { visit edit_user_path(user) }
            it { should have_selector('title', text: 'Sign in') }
          end
          describe "submitting to the update action" do
            before { put user_path(user) }
            specify { response.should redirect_to(signin_path) }
          end
          describe "visiting the user index" do
            before { visit users_path }
            it { should have_selector('title', text: 'Sign in') }
          end
          
          describe "when attempting to visit a protected page" do
            before do
              visit edit_user_path(user) #redirects to signin
              fillsigninandclick user
            end
            describe "after signing in" do 
              it "should render the desired protected page" do
                 page.should have_selector('title', text: 'Edit user')
              end
            end
          end  #in the users controller  
        end
      end

      describe "as wrong user" do
        let(:user) { FactoryGirl.create(:user) }
        let(:different_user) { FactoryGirl.create(:user, email: "different@example.com") }
        before { sign_in user }

        describe "visiting Users#edit page" do
          before { visit edit_user_path(different_user) }
          it { should_not have_selector('title', text: full_title('Edit user')) }
        end

        describe "submitting a PUT request to the Users#update action" do
          before { put user_path(different_user) }
          specify { response.should redirect_to(root_path) }
        end
      end

      describe "as non-admin user" do
        let(:user) { FactoryGirl.create(:user) }
        let(:non_admin) { FactoryGirl.create(:user) }

        before { sign_in non_admin }

        describe "submitting a DELETE request to the Users#destroy action" do
          before { delete user_path(user) }
          specify { response.should redirect_to(root_path) }        
        end
      end
    end
    
  end
end