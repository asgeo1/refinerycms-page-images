require "spec_helper"

describe "page resources" do
  refinery_login_with :refinery_user

  let(:configure) {}
  let(:page_for_resources) { FactoryGirl.create(:page) }
  let(:resource) { FactoryGirl.create(:resource) }
  let(:navigate_to_edit) { visit refinery.edit_admin_page_path(page_for_resources) }
  let(:page_resources_tab_id) { "#custom_#{::I18n.t(:'refinery.plugins.refinery_page_resources.tab_name')}_tab" }

  let(:setup_and_visit) do
    configure
    page_for_resources
    navigate_to_edit
  end

  # Regression test for #100 and #102
  it "can add a page resource to the db", :js => true do

    resource
    setup_and_visit

    page_for_resources.resources.count.should eq 0

    page.find("#{page_resources_tab_id} a").click

    # Add the first Resource
    click_link "Add Resource"

    page.should have_selector 'iframe#dialog_iframe'
    page.within_frame('dialog_iframe') do
      find(:css, "#existing_resource_area img#resource_#{resource.id}").click
      click_button ::I18n.t('button_text', :scope => 'refinery.admin.resources.existing_resource')
    end

    # resource should be visable on the page
    page.should have_selector("#page_resources li#resource_#{resource.id}")

    click_button "Save"

    # resource should be in the db
    page_for_resources.resources.count.should eq 1

  end

  context "with resources" do

    let(:page_for_resources) { FactoryGirl.create(:page_with_resource) }

    # Regression test for #100 and #102
    it "can remove a page resource to the db", :js => true do

      setup_and_visit

      page_for_resources.resources.count.should eq 1

      page.find("#{page_resources_tab_id} a").click

      page.should have_selector("#page_resources li#resource_#{page_for_resources.resources.first.id}")

      resource_li_tag = page.find("#page_resources li:first-child")
      resource_li_tag.hover
      within(resource_li_tag) { page.find('img:first-child').click }

      page.should_not have_selector("#page_resources li#resource_#{page_for_resources.resources.first.id}")

      click_button "Save"

      page_for_resources.resources.count.should eq 0

    end
  end

end

