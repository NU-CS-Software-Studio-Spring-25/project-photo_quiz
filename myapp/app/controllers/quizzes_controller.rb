# QuizzesController handles displaying quizzes associated with the user or course.
class QuizzesController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:course]
      course = current_user.owned_courses.find_by(id: params[:course])
      students = course ? course.students : Student.none

      default_image = ActionController::Base.helpers.asset_path("default-profile.png")

      if students.empty?
        render json: { error: "No students found for the selected course." }, status: :unprocessable_entity
        return
      end

      questions = students.map do |student|
        photo_url = if student.profile_picture.attached?
          Rails.application.routes.url_helpers.rails_blob_url(
            student.profile_picture,
            host: request.base_url
          )
        else
          view_context.asset_url("default-profile.png", host: request.base_url)
        end

        {
          photo_url:    photo_url,
          options:      students.sample([3, students.size].min)
                            .map { |s| "#{s.first_name} #{s.last_name}" },
          correct_name: "#{student.first_name} #{student.last_name}"
        }
      end

      render json: questions
    else
      @courses = current_user.owned_courses.order(:name)
    end
  end

  def results
    @course_id = params[:course_id]
    @correct_answers = params[:correct].to_i
    @total_questions = params[:total].to_i

    @course = current_user.owned_courses.find_by(id: @course_id)

    # For now, we're just displaying the current quiz score.
    # Mastery and progress will be added here later.
    if @course.nil? && @course_id.present?
      flash[:alert] = "Could not find the specified course."
    end
  end
end
