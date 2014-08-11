require 'spec_helper'

describe Refinery::PageResources::Engine do
  before(:all) do
    class Refinery::PageResources::EnableForMock
      class Model; end
      class Tab; end
    end
  end

  after(:all) do
    Refinery::PageResources.instance_eval { remove_const(:EnableForMock) }
  end

  before(:each) do
    Refinery::PageResources.config.stub(:enable_for).and_return(enable_for_config)
  end

  def enable_for_config
    [{ :model => 'Refinery::PageResources::EnableForMock::Model',
       :tab => 'Refinery::PageResources::EnableForMock::Tab' }]
  end

  describe "attach initializer" do
    it "calls attach on all configured model" do
      Refinery::PageResources.config.stub(:enable_for).and_return(enable_for_config)

      Refinery::PageResources::EnableForMock::Model.should_receive(:has_many_page_resources).once
      Refinery::Page.should_not_receive(:has_many_page_resources)
      ActionDispatch::Reloader.prepare!
    end
  end

  describe "attach_initialize_tabs!" do
    it "registers tabs for all configured engine" do
      Refinery::PageResources::EnableForMock::Tab.should_receive(:register).once
      Refinery::Pages::Tab.should_not_receive(:register)
      Refinery::PageResources::Engine.initialize_tabs!
    end
  end

end
