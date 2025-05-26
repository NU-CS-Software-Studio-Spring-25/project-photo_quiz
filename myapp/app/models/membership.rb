# Membership model for managing user enrollments in courses
# This model handles the association between users, students, and courses.
class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :student
  belongs_to :course
  validates :student_id, uniqueness: { scope: :course_id, message: "Student is already enrolled in this course" }
end
