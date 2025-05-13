class QuizzesController < ApplicationController
  include Rails.application.routes.url_helpers

  def index
    if params[:course]
      students = Student.where(course: params[:course])

      default_image = ActionController::Base.helpers.asset_path("default-profile.png")

      if students.empty?
        render json: { error: "No students found for the selected course." }, status: :unprocessable_entity
        return
      end

      questions = students.map do |student|
        {
          photo_url: student.profile_picture.attached? ? url_for(student.profile_picture) : default_image,
          options: students.sample([3, students.size].min).map { |s| "#{s.first_name} #{s.last_name}" },
          correct_name: "#{student.first_name} #{student.last_name}"
        }
      end

      render json: questions
    else
      @courses = Student.distinct.pluck(:course)
    end
  end
end
