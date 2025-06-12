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
          student_id:   student.id,
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

  def record_answer
    student = Student.find_by(id: params[:student_id])
    is_correct = params[:correct].to_s == 'true' 

    if student && is_correct && !student.learned?
      student.increment!(:name_mastery)
      if student.name_mastery >= 2
        student.update!(learned: true)
      else
        student.save! # Save the incremented name_mastery if not yet learned
      end
      render json: { status: 'success', name_mastery: student.name_mastery, learned: student.learned? }, status: :ok
    elsif student && is_correct && student.learned?
      render json: { status: 'success_already_learned', name_mastery: student.name_mastery, learned: student.learned? }, status: :ok
    elsif !student
      render json: { status: 'error', message: 'Student not found' }, status: :not_found
    else # Incorrect answer or other cases
      render json: { status: 'ignored' }, status: :ok
    end
  rescue ActiveRecord::RecordNotFound
    render json: { status: 'error', message: 'Student not found' }, status: :not_found
  rescue => e
    Rails.logger.error "Error in record_answer: #{e.message}"
    render json: { status: 'error', message: 'Internal server error' }, status: :internal_server_error
  end

  def results
    @course_id = params[:course_id]
    @correct_answers = params[:correct].to_i
    @total_questions = params[:total].to_i
    @course            = current_user.owned_courses.find_by(id: @course_id)

    # ensure we always have a relation to work with
    students_in_course = @course ? @course.students : Student.none

    # compute bucket counts
    total             = students_in_course.count
    @mastered_count   = students_in_course.where("name_mastery >= ?", 2).count
    @learning_count   = students_in_course.where(name_mastery: 1).count
    @unlearned_count  = students_in_course.where(name_mastery: 0).count

    # percentages for Chart.js
    if total > 0
      @name_mastery2 = (@mastered_count.to_f  / total * 100).round(1)
      @name_mastery1 = (@learning_count.to_f  / total * 100).round(1)
      @name_mastery0 = (@unlearned_count.to_f / total * 100).round(1)
    else
      @name_mastery2 = @name_mastery1 = @name_mastery0 = 0
    end

    # overall learning-progress percentage
    max_points = total * 2.0
    @learning_progress_percentage =
      if max_points > 0
        ((students_in_course.sum(:name_mastery).to_f / max_points) * 100).round(1)
      else
        0
      end

    # optional: individual student mastery details
    @students_in_course_with_mastery =
      students_in_course.select(:id, :first_name, :last_name, :name_mastery, :learned)
                        .order(:last_name, :first_name)
  end
end
