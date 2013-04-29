#describe "StaticPages" do
#  describe "GET /static_pages" do
#    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
#      get static_pages_index_path
#      response.status.should be(200)
#    end
#  end
#end

#capybara gem provides visit and page objects
#spec/support directory included by default
require 'spec_helper'
include ApplicationHelper

# Tests for the static pages
describe "Static pages" do
  subject { page } #prefix all the should statements
  #let(:base_title) { "Ruby on Rails Tutorial Sample App" }

  shared_examples_for "all static pages" do
    it { should have_selector('h1',    text: heading) }
    it { should have_selector('title', text: full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }  #calls this before every 'it' block
    let (:heading) {'Sample App'}
    let (:page_title) {''}
    it_should_behave_like "all static pages" 
    it { should_not have_selector('title', text:full_title('Home')) }

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          page.should have_selector("li##{item.id}", text: item.content)
        end
      end
    end
  end
  
  describe "Help page" do
    before { visit help_path }  #calls this before every 'it' block
    let (:heading) {'Help'}
    let (:page_title) {'Help'}
    it_should_behave_like "all static pages" 
    #it "should have the content 'Help'" do
     #  page.should have_selector('h1', :text => 'Help')
    #end
    #it "should have the title 'Help'" do
     # page.should have_selector('title',:text => "#{base_title} | Help")
   # end
  end
  
  describe "About page" do
    before { visit about_path }  #calls this before every 'it' block
    let (:heading) {'About'}
    let (:page_title) {'About'}
    it_should_behave_like "all static pages" 
  end
  
  describe "Contact page" do
    before { visit contact_path }  #calls this before every 'it' block
    let (:heading) {'Contact'}
    let (:page_title) {'Contact'}
    it_should_behave_like "all static pages" 
  end
end