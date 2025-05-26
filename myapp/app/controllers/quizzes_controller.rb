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
        {
          photo_url: (student.profile_picture.attached? ?
            Rails.application.routes.url_helpers.rails_blob_url(student.profile_picture) :
            default_image),
          options: students.sample([ 3, students.size ].min).map { |s| "#{s.first_name} #{s.last_name}" },
          correct_name: "#{student.first_name} #{student.last_name}"
        }
      end

      render json: questions
    else
      @courses = current_user.owned_courses.order(:name)
    end
  end
end
