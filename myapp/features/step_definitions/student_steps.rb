require 'rspec/expectations'

Given('a user with full name {string} exists and owns a course with code {string}') do |name, code|
  @user = User.create!(
    email: "professor@example.com",
    password: "password123",
    full_name: name
  )
  @course = Course.create!(
    name: "Test Course",
    code: code,
    user: @user
  )
end

Given('a student named {string} is in the course {string}') do |name, code|
  course = Course.find_by(code: code)
  raise "Course with code #{code} not found" unless course

  first, last = name.split
  student = Student.create!(
    first_name: first,
    last_name: last
  )

  Membership.create!(student: student, user: course.user, course: course)
end

When('the student visits {string}') do |path|
  visit path
end

When('they fill in {string} with {string}') do |field, value|
  fill_in field, with: value
end

When('they upload a profile picture') do
  attach_file("student[profile_picture]", Rails.root.join("spec/fixtures/files/sample.jpg"), make_visible: true)
end

When('they click {string}') do |button|
  click_button button
end

Then('they should see {string}') do |text|
  expect(page).to have_content(text)
end

When('the user logs in as {string} with password {string}') do |email, password|
  visit new_user_session_path
  fill_in "Email", with: email
  fill_in "Password", with: password
  click_button "Log in"
end

When('they visit the student directory') do
  visit students_path
end
