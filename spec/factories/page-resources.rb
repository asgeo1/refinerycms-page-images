FactoryGirl.define do
  factory :page_with_resource, :parent => :page do
    after(:create) { |p| p.resources << FactoryGirl.create(:resource) }
  end

  factory :blog_post_with_resource, :parent => :blog_post do
    after(:create) { |b| b.resources << FactoryGirl.create(:resource) }
  end if defined? Refinery::Blog::Post
end
