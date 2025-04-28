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
  :course => 'CS 397'}
]

more_students.each do |student|
  Student.create!(student)
end
