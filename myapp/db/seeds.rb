# Seed Professors
professors = [
  { first_name: 'Ana', last_name: 'Kurdia', email: 'ana.kurdia@example.com', password: 'password' },
  { first_name: 'Connor', last_name: 'Bain', email: 'connor.bain@example.com', password: 'password' }
]
professors.each do |professor_data|
  Professor.create!(professor_data)
end
# Seed Courses
courses = [
  { title: 'CS 397' },
  { title: 'CS 150' },
  { title: 'ENG 210' },
  { title: 'HIST 210' }
]
courses.each do |course_data|
  Course.create!(course_data)
end
# Seed Students
more_students = [
  { first_name: 'Paula', last_name: 'Fregene', course: 'CS 397' },
  { first_name: 'Sophie', last_name: 'Shin', course: 'CS 397' },
  { first_name: 'Yuyang', last_name: 'Pan', course: 'CS 397' },
  { first_name: 'Samar', last_name: 'Salaam', course: 'CS 397' },
  { first_name: 'Jack', last_name: 'Olantern', course: 'CS 150' },
  { first_name: 'Kim', last_name: 'Okay', course: 'CS 310' },
  { first_name: 'Watt', last_name: 'Electric', course: 'HIST 210' },
  { first_name: 'Jenny', last_name: 'Jiang', course: 'PHIL 210' },
  { first_name: 'Mark', last_name: 'Brown', course: 'MATH 210' },
  { first_name: 'Kenny', last_name: 'Lin', course: 'English 210' },
  { first_name: 'Pom', last_name: 'Merang', course: 'CHEM 150' },
  { first_name: 'Jj', last_name: 'Jung', course: 'POL 310' },
  { first_name: 'Wow', last_name: 'Ee', course: 'KOR 450' }
]
more_students.each do |student|
  Student.create!(student)
end
# Seed Memberships (connect professors, courses, and students)
memberships = [
  { professor_id: Professor.find_by(email: 'ana.kurdia@example.com').id, course_id: Course.find_by(title: 'CS 397').id, student_id: Student.find_by(first_name: 'Paula', last_name: 'Fregene').id },
  { professor_id: Professor.find_by(email: 'ana.kurdia@example.com').id, course_id: Course.find_by(title: 'CS 397').id, student_id: Student.find_by(first_name: 'Sophie', last_name: 'Shin').id },
  { professor_id: Professor.find_by(email: 'connor.bain@example.com').id, course_id: Course.find_by(title: 'CS 150').id, student_id: Student.find_by(first_name: 'Jack', last_name: 'Olantern').id }
]
memberships.each do |membership_data|
  Membership.create!(membership_data)
end

require 'faker'
# Seed Professors
40.times do
  Professor.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.email,
    password: 'password' # Default password for all professors
  )
end
# Seed Courses
10.times do
  Course.create!(
    title: Faker::Educator.course_name
  )
end
# Seed Students
40.times do
  Student.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    profile_picture: Faker::Avatar.image, # Generates a random avatar URL
    name_mastery: rand(0..5), # Random mastery level between 0 and 5
    learned: [true, false].sample # Randomly assign true or false
  )
end
# Seed Memberships (connect Professors, Courses, and Students)
40.times do
  Membership.create!(
    professor_id: Professor.pluck(:id).sample, # Random professor
    course_id: Course.pluck(:id).sample,       # Random course
    student_id: Student.pluck(:id).sample      # Random student
  )
end
