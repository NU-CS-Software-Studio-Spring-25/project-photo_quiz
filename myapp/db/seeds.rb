# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

more_students = [
  {:first_name => 'Paula', :last_name => 'Fregene',
    :course => 'CS 397'},
  {:first_name => 'Sophie', :last_name => 'Shin',
  :course => 'CS 397'},
  {:first_name => 'Yuyang', :last_name => 'Pan',
  :course => 'CS 397'},
  {:first_name => 'Samar', :last_name => 'Salaam',
  :course => 'CS 397'},
  {:first_name => 'Jack', :last_name => 'Olantern',
  :course => 'CS 150'},
  {:first_name => 'Kim', :last_name => 'Okay',
  :course => 'CS 310'},
  {:first_name => 'Watt', :last_name => 'Electric',
  :course => 'HIST 210'},
  {:first_name => 'Jenny', :last_name => 'Jiang',
  :course => 'PHIL 210'},
  {:first_name => 'Mark', :last_name => 'Brown',
  :course => 'MATH 210'},
  {:first_name => 'Kenny', :last_name => 'Lin',
  :course => 'English 210'},
  {:first_name => 'Pom', :last_name => 'Merang',
  :course => 'CHEM 150'},
  {:first_name => 'Jj', :last_name => 'Jung',
  :course => 'POL 310'},
  {:first_name => 'Wow', :last_name => 'Ee',
  :course => 'KOR 450'}
]

more_students.each do |student|
  Student.create!(student)
end
