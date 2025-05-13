# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create Users (professors)
prof1 = User.find_or_initialize_by(email: "alice@example.com")
prof1.full_name             = "Alice Smith"
prof1.password              = "password"
prof1.password_confirmation = "password"
prof1.save!

prof2 = User.find_or_initialize_by(email: "bob@example.com")
prof2.full_name             = "Bob Jones"
prof2.password              = "password"
prof2.password_confirmation = "password"
prof2.save!

# Create Students
student1 = Student.create!(first_name: "Paula", last_name: "Fregene")
student2 = Student.create!(first_name: "Sophie", last_name: "Shin")
student3 = Student.create!(first_name: "Yuyang", last_name: "Pan")


# Create Courses
course1 = Course.create!(name: "CS 397")
course2 = Course.create!(name: "CS 150")

# Create Memberships
Membership.create!(student: student1, user: prof1, course: course1)
Membership.create!(student: student2, user: prof1, course: course1)
Membership.create!(student: student3, user: prof2, course: course2)
Membership.create!(student: student1, user: prof2, course: course2)




# more_students = [
#   { first_name: 'Paula', last_name: 'Fregene',
#     course: 'CS 397' },
#   { first_name: 'Sophie', last_name: 'Shin',
#   course: 'CS 397' },
#   { first_name: 'Yuyang', last_name: 'Pan',
#   course: 'CS 397' },
#   { first_name: 'Samar', last_name: 'Salaam',
#   course: 'CS 397' },
#   { first_name: 'Jack', last_name: 'Olantern',
#   course: 'CS 150' },
#   { first_name: 'Kim', last_name: 'Okay',
#   course: 'CS 310' },
#   { first_name: 'Watt', last_name: 'Electric',
#   course: 'HIST 210' },
#   { first_name: 'Jenny', last_name: 'Jiang',
#   course: 'PHIL 210' },
#   { first_name: 'Mark', last_name: 'Brown',
#   course: 'MATH 210' },
#   { first_name: 'Kenny', last_name: 'Lin',
#   course: 'English 210' },
#   { first_name: 'Pom', last_name: 'Merang',
#   course: 'CHEM 150' },
#   { first_name: 'Jj', last_name: 'Jung',
#   course: 'POL 310' },
#   { first_name: 'Wow', last_name: 'Ee',
#   course: 'KOR 450' }
# ]

# more_students.each do |student|
#   Student.create!(student)
# end
