require 'spec_helper'
describe ApplicationHelper do

  describe "full_title" do
    it "should include the page title" do
      full_title("foo").should =~ /foo/ #regex find foo
    end

    it "should include the base title" do
      full_title("foo").should =~ /^Ruby on Rails Tutorial Sample App/ #regex start with
    end

    it "should not include a bar for the home page" do
      full_title("").should_not =~ /\|/ #regex find the bar char
    end
  end
end