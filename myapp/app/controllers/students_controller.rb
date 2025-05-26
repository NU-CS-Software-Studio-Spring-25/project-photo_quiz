# Manage students in the application
# StudentsController handles CRUD operations for students, including searching and filtering by courses.
class StudentsController < ApplicationController
  include StudentsHelper
  before_action :authenticate_user!, except: [ :new ]
  before_action :set_student, only: [ :show, :edit, :update, :destroy, :confirm_destroy ]
  before_action :load_courses, only: %i[new edit create update]

  # GET /students
  # GET /students.json
  def index
    students_scope = current_user.students.includes(:courses).distinct
    courses_scope = current_user.courses.includes(:students).distinct

    param_query = params[:query]
    if param_query.present?
      query = param_query.downcase.strip
      query_words = query.split
      student_conditions, course_conditions, query_params = build_query_conditions(query_words)

      students_filtered = students_scope
        .left_outer_joins(:courses)
        .where("#{student_conditions} OR #{course_conditions}", **query_params)
        .distinct

      @students = students_filtered.page(params[:page]).per(50)
      @courses = courses_scope.where(id: students_filtered.joins(:courses).select("courses.id"))
    else
      @students = students_scope.page(params[:page]).per(20)
      @courses = courses_scope
    end
    @students_grouped = group_students(@students)
  end

  # GET /students/1
  # GET /students/1.json
  def show
  end

  # GET /students/new
  def new
    @student = Student.new
  end

  # GET /students/1/edit
  def edit
  end

  # POST /students
  # POST /students.json
  def create
    @student = Student.new(student_params)

    respond_to do |format|
      if @student.save
        handle_course_assignment(format)
      else
        respond_with_error(format, @student.errors, "Failed to create student. Please make sure First name, Last name, and Course are filled.")
      end
    end
  end

  # PATCH/PUT /students/1
  # PATCH/PUT /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        respond_with_success(format, "Student was successfully updated.")
      else
        respond_with_error(format, @student.errors, "Failed to update student. Please make sure First name, Last name, and Course are filled.")
      end
    end
  end

  # DELETE /students/1
  # DELETE /students/1.json
  def destroy
    respond_to do |format|
      if @student.destroy
        respond_to_destroy(format, "Student was successfully destroyed.")
      else
        respond_with_error(format, @student.errors, "Failed to destroy student.")
      end
    end
  end

  private

    def load_courses
      @courses = current_user.owned_courses
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def student_params
      params.require(:student).permit(:first_name, :last_name, :profile_picture)
    end

end
