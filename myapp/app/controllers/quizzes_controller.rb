class QuizzesController < ApplicationController
    before_action :authenticate_user!

    def index
      if params[:course]
        course = Course.find_by(name: params[:course])
        students = course ? course.students : Student.none
        

        # Use ActionController::Base.helpers.asset_path for the default image
        default_image = ActionController::Base.helpers.asset_path("default-profile.png")

        # Handle case where no students are found
        if students.empty?
          render json: { error: "No students found for the selected course." }, status: :unprocessable_entity
          return
        end

        questions = students.map do |student|
          {
            photo_url: student.profile_picture || default_image, # Use default image if profile_picture is nil
            options: students.sample([ 3, students.size ].min).map { |s| "#{s.first_name} #{s.last_name}" }, # Ensure no error if fewer than 3 students
            correct_name: "#{student.first_name} #{student.last_name}"
          }
        end
        render json: questions
      else
        @courses = Course.order(:name).pluck(:name)
      end
    end
end
