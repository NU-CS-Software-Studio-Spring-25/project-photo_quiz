require 'faker'

# Seed Professors
users = [
  { full_name: 'Alice Smith', email: 'alice@example.com', password: 'password', password_confirmation: 'password' },
  { full_name: 'Bob Jones',   email: 'bob@example.com',   password: 'password', password_confirmation: 'password' },
]

users.each do |attrs|
  u = User.find_or_initialize_by(email: attrs[:email])
  u.full_name             = attrs[:full_name]
  u.password              = attrs[:password]
  u.password_confirmation = attrs[:password_confirmation]
  u.save!
end

# Seed Courses
courses = [
  { name: 'CS 397' },
  { name: 'CS 150' },
  { name: 'ENG 210' },
  { name: 'HIST 210' }
]
course_records = courses.map { |data| Course.create!(data) }
# Seed Students
students = [
  { first_name: 'Paula', last_name: 'Fregene'},
  { first_name: 'Sophie', last_name: 'Shin'},
  { first_name: 'Yuyang', last_name: 'Pan'},
  { first_name: 'Samar', last_name: 'Salaam'},
  { first_name: 'Jack', last_name: 'Olantern'},
  { first_name: 'Kim', last_name: 'Okay'},
  { first_name: 'Watt', last_name: 'Electric'},
  { first_name: 'Jenny', last_name: 'Jiang'},
  { first_name: 'Mark', last_name: 'Brown'},
  { first_name: 'Kenny', last_name: 'Lin'},
  { first_name: 'Pom', last_name: 'Merang'},
  { first_name: 'Jj', last_name: 'Jung'},
  { first_name: 'Wow', last_name: 'Ee'}
]
student_records = students.map { |data| Student.create!(data) }
# Seed Memberships
student_records.each do |student|
  # Assign each student to 1–2 courses
  course_records.sample(2).each do |course|
    Membership.create!(
      student_id: student.id,
      course_id: course.id,
      user_id: user_records.sample.id # Assign to a random professor
    )
  end
end
# Seed Professors
40.times do
  User.create!(
    full_name: "#{Faker::Name.first_name} #{Faker::Name.last_name}",
    email: Faker::Internet.unique.email,
    password: 'password',
    password_confirmation: 'password'
  )
end
# Seed Courses
10.times do
  Course.create!(
    name: Faker::Educator.course_name
  )
end
# Seed Students
40.times do
  student = Student.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    profile_picture: Faker::Avatar.image, # Generates a random avatar URL
    # name_mastery: rand(0..5), # Random mastery level between 0 and 5
    # learned: [true, false].sample # Randomly assign true or false
  )
  # Use Faker to generate a URL for the profile picture (this will be an image URL string)
  student.profile_picture = Faker::Avatar.image(slug: student.first_name.downcase, size: "150x150", format: "png")
  student.save!
end
# Seed Memberships (connect Professors, Courses, and Students)
40.times do
  Membership.create!(
    user_id: User.pluck(:id).sample, # Random professor
    course_id: Course.pluck(:id).sample,       # Random course
    student_id: Student.pluck(:id).sample      # Random student
  )
end
