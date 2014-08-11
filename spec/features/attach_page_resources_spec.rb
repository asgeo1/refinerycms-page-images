require "spec_helper"

describe "attach page resources" do
  refinery_login_with :refinery_user

  # No-op block : use default configuration by default
  let(:configure) {}
  let(:create_page) { FactoryGirl.create(:page) }
  let(:navigate_to_edit)  { click_link "Edit this page" }
  let(:page_resources_tab_id) { "#custom_#{::I18n.t(:'refinery.plugins.refinery_page_resources.tab_name')}_tab"  }

  let(:setup_and_visit) do
    configure
    create_page
    visit refinery.admin_pages_path
    navigate_to_edit
  end

  it "shows resources tab" do
    setup_and_visit
    within page_resources_tab_id do
      page.should have_content("Resources")
    end
  end

  # This spec actually is broken in a way because Add Resource link would
  # be visible to capybara even if we don't click on Resources tab.
  it "shows add resource link" do
    setup_and_visit
    within page_resources_tab_id do
      click_link "Resources"
    end

    page.should have_content("Add Resource")
  end

  context "with caption and WYSIWYG disabled" do
    let(:configure) do
      Refinery::PageResources.config.wysiwyg  = false
      Refinery::PageResources.config.captions = true
    end

    let(:create_page) { FactoryGirl.create(:page_with_resource) }
    let(:navigate_to_edit) { page.find('a[tooltip="Edit this page"]').click }

    it "shows a plain textarea when editing caption", js: true do
      setup_and_visit
      page.find("#{page_resources_tab_id} a").click
      resource_li_tag = page.find("#page_resources li:first-child")

      resource_li_tag.hover
      within(resource_li_tag) { page.find('img.caption').click }

      page.find('.ui-dialog textarea').should be_visible
    end
  end

end
