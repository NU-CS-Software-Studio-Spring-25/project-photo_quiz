require 'faker'
require 'open-uri'

# --- Seed Professors ---
users = [
  { full_name: 'Alice Smith', email: 'alice@example.com', password: 'password', password_confirmation: 'password' },
  { full_name: 'Bob Jones',   email: 'bob@example.com',   password: 'password', password_confirmation: 'password' },
  { full_name: 'Charlie Brown', email: 'charlie@example.com', password: 'password', password_confirmation: 'password' },
  { full_name: 'Chloe Kim', email: 'cloi@example.com', password: 'password', password_confirmation: 'password' },
  { full_name: 'Watt Electric', email: 'power@example.com', password: 'password', password_confirmation: 'password' }
]

users.each do |attrs|
  u = User.find_or_initialize_by(email: attrs[:email])
  u.full_name             = attrs[:full_name]
  u.password              = attrs[:password]
  u.password_confirmation = attrs[:password_confirmation]
  u.save!
end

user_records = User.all.to_a

# --- Seed Courses (unique, no duplicates) ---
courses = [
  { name: 'CS 397' },
  { name: 'CS 150' },
  { name: 'ENG 210' },
  { name: 'HIST 210' }
]

course_records = courses.map.with_index do |data, i|
  Course.create!(data.merge(user: user_records[i % user_records.length]))
end

# Add some random courses, but make sure names are unique
10.times do |i|
  name = Faker::Educator.unique.course_name.gsub(/[^\w\s\-']/, '').slice(0, 24)
  
  Course.create!(
    name: name,
    user: user_records[i % user_records.length]
  )
end

all_courses = Course.all.to_a

# --- Seed Students (unique, no duplicates) ---
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

# Add some random students
40.times do
  first_name = Faker::Name.first_name.gsub(/[^\w\s\-']/, '')
  last_name = Faker::Name.last_name.gsub(/[^\w\s\-']/, '')

  student = Student.create!(
    first_name: first_name,
    last_name: last_name
  )

  avatar_url = Faker::Avatar.image(slug: student.first_name.downcase, size: "150x150", format: "png")
  downloaded_image = URI.open(avatar_url)
  student.profile_picture.attach(
    io: downloaded_image,
    filename: "#{student.first_name.downcase}.png",
    content_type: "image/png"
  )
end

all_students = Student.all.to_a

user_records.each do |user|
  user_courses = Course.where(user: user)

  user_courses.each do |course|
    all_students.sample(rand(5..10)).each do |student|
      Membership.find_or_create_by!(
        student: student,
        course: course,
        user: user 
      )
    end
  end
end