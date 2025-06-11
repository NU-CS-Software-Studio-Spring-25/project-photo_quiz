Given('a user with full name {string} exists and owns a course with code {string}') do |name, code|
    user = User.create!(
      email: "professor@example.com",
      password: "password123",
      full_name: name
    )
    Course.create!(name: "CS397", user: user, code: code)
  end
  
  When('the student visits {string}') do |path|
    visit path
  end
  
  When('they fill in {string} with {string}') do |field, value|
    fill_in field, with: value
  end
  
  When('they upload a profile picture') do
    attach_file("student_profile_picture", Rails.root.join("spec", "fixtures", "files", "sample.jpg"), make_visible: false)
  end
  
  When('they click {string}') do |button_text|
    click_button button_text
  end
  
  Then('they should see {string}') do |expected_text|
    expect(page).to have_text(expected_text)
  end
  