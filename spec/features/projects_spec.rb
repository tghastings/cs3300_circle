require 'rails_helper'

test_email = "test@example.com"
test_password = "f4k3p455w0rd"

RSpec.feature "Projects", type: :feature do
  context "Create new project" do
    before(:each) do
      user = User.create!(:email => test_email, :password => test_password)
      login_as(user, :scope => :user)
      visit new_project_path
      within(".form-inline") do
        fill_in "project[name]", with: "Test Name"
      end
    end

    scenario "should be successful" do
      fill_in "project[description]", with: "Test description"
      click_button "Create Project"
      expect(page).to have_content("Project was successfully created")
    end

    scenario "should fail" do
      click_button "Create Project"
      expect(page).to have_content("Description can't be blank")
    end
  end

  context "Update Project" do
    let(:project) { Project.create(name: "Test Name", description: "Test Content") }
    before(:each) do
      user = User.create!(:email => test_email, :password => test_password)
      login_as(user, :scope => :user)
      visit edit_project_path(project)
    end

    scenario "should be successful" do
      within(".form-inline") do
        fill_in "project[description]", with: "New description content"
      end
      click_button "Update Project"
      expect(page).to have_content("Project was successfully updated")
    end

    scenario "should fail" do
      within(".form-inline") do
        fill_in "Description", with: ""
      end
      click_button "Update Project"
      expect(page).to have_content("Description can't be blank")
    end
  end

  context "Remove existing project" do
    let!(:project) { Project.create(name: "Test name", description: "test content") }
    scenario "remove project" do
      user = User.create!(:email => test_email, :password => test_password)
      login_as(user, :scope => :user)
      visit projects_path
      click_link "Delete"
      expect(page).to have_content("Project was successfully destroyed")
      expect(Project.count).to eq(0)
    end
  end
end
