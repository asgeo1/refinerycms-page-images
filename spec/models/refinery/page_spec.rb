require 'spec_helper'

module Refinery
  describe Page do
    it "can have resources added" do
      page = FactoryGirl.create(:page)
      page.resources.count.should eq(0)

      page.resources << FactoryGirl.create(:resource)
      page.resources.count.should eq(1)
    end

    describe '#resources_with_captions' do
      it 'returns an resources_with_captions collection' do
        page = FactoryGirl.create(:page)
        page.resources_with_captions.count.should eq(0)

        page.resources << FactoryGirl.create(:resource)
        page.resources_with_captions.count.should eq(1)
      end

      it 'returns an resource and a caption' do
        page = FactoryGirl.create(:page)
        page.resources_with_captions.count.should eq(0)

        page.resources << FactoryGirl.create(:resource)
        page.resources_with_captions.first[:resource].should be_a(Refinery::Resource)
        page.resources_with_captions.first[:caption].should be_a(String)
      end

    end

    describe "#resources_attributes=" do
      it "adds resources" do
        page = FactoryGirl.create(:page)
        resource = FactoryGirl.create(:resource)

        page.resources.count.should == 0
        page.update_attributes({:resources_attributes => {"0" => {"id" => resource.id}}})

        page.resources.count.should == 1
      end

      it "deletes specific resources" do
        page = FactoryGirl.create(:page)
        resources = [FactoryGirl.create(:resource), FactoryGirl.create(:resource)]
        page.resources = resources

        page_resource_to_keep = page.resource_pages.find do |resource_page|
          resource_page.resource_id == resources.first.id
        end
        page.update_attributes(:resources_attributes => {
          "0" => {
            "id" => page_resource_to_keep.resource_id.to_s,
            "resource_page_id" => page_resource_to_keep.id
          },
        })

        page.resources.should eq([resources.first])
      end

      it "deletes all resources" do
        page = FactoryGirl.create(:page)
        resources = [FactoryGirl.create(:resource), FactoryGirl.create(:resource)]
        page.resources = resources

        page.update_attributes(:resources_attributes => {"0" => {"id"=>""}})

        page.resources.should be_empty
      end

      it "reorders resources" do
        page = FactoryGirl.create(:page)
        resources = [FactoryGirl.create(:resource), FactoryGirl.create(:resource)]
        page.resources = resources

        first_page_resource = page.resource_pages.find do |resource_page|
          resource_page.resource_id == resources.first.id
        end
        second_page_resource = page.resource_pages.find do |resource_page|
          resource_page.resource_id == resources.second.id
        end

        page.update_attributes(:resources_attributes => {
          "0" => {
            "id" => second_page_resource.resource_id,
            "resource_page_id" => second_page_resource.id,
          },
          "1" => {
            "id" => first_page_resource.resource_id,
            "resource_page_id" => first_page_resource.id,
          },
        })

        page.resources.should eq([resources.second, resources.first])
      end
    end
  end
end
