# QuizzesController handles displaying quizzes associated with the user or course.
class QuizzesController < ApplicationController
  include QuizzesHelper
  before_action :authenticate_user!

  def index
    owned_courses = current_user.owned_courses
    course_id = params[:course]

    return QuizzesHelper.load_courses(owned_courses) unless course_id.present?

    course = owned_courses.find_by(id: course_id)
    students = course ? course.students : Student.none

    return QuizzesHelper.render_no_students_error if students.empty?

    default_image = ActionController::Base.helpers.asset_path("default-profile.png")

    questions = QuizzesHelper.build_questions(students, default_image)

    render json: questions
  end

end
