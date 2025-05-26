# Helper module for quizzes
# This module provides utility methods for quizzes, such as generating full names and photo URLs for students.
module QuizzesHelper

    def load_courses(courses)
        @courses = courses.order(:name)
    end

    def render_no_students_error
        render json: { error: "No students found for the selected course." }, status: :unprocessable_entity
    end

    def build_questions(students, default_image)
        students.map do |student|
        {
            photo_url: photo_url_for(student, default_image),
            options: name_options(students, student),
            correct_name: full_name(student)
        }
        end
  end

    def name_options(students, correct_student)
        # Pick 3 or fewer students (excluding the correct one), shuffle, then get full names
        others = students.reject { |student| student == correct_student }
        selected_students = others.sample([3, others.size].min)
        selected_students.map { |student| QuizzesHelper.full_name(student) }
    end

    def full_name(student)
        "#{student.first_name} #{student.last_name}"
    end

    def photo_url_for(student, default_image)
        profile_picture = student.profile_picture
        if profile_picture.attached?
        Rails.application.routes.url_helpers.rails_blob_url(profile_picture)
        else
        default_image
        end
    end

    module_function :load_courses, :render_no_students_error, :build_questions
end
