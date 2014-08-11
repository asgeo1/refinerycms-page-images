require 'spec_helper'

module Refinery
  describe BlogPost do
    it "should not have resources" do
      blog = FactoryGirl.create(:blog_post)
      blog.resources.count.should == 0
    end

    it "should have resources" do
      blog = FactoryGirl.create(:blog_post_with_resource)
      blog.resources.count.should == 1
    end
  end
end if defined?(Refinery::Blog::Post)
