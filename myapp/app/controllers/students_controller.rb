class StudentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_student, only: [ :show, :edit, :update, :destroy, :confirm_destroy ]
  before_action :load_courses,  only: %i[ new edit create update ]

  # GET /students
  # GET /students.json
  def index
    @courses = Course.includes(:students).all
    @students = Student.all
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
        if params[:course_id].present?
          begin
            course = Course.find(params[:course_id])
            @student.update(course: course.name)
            Membership.create!(student: @student, course: course, user: current_user)
  
            format.html { redirect_to students_path, notice: "Student was successfully created." }
            format.json { render :show, status: :created, location: @student }
          rescue ActiveRecord::RecordNotFound
            format.html { redirect_to new_student_path, alert: "Selected course not found." }
            format.json { render json: { error: "Course not found" }, status: :unprocessable_entity }
          end
  
        elsif params[:course_code].present?
          course = Course.find_by(code: params[:course_code].strip.upcase)
  
          if course
            @student.update(course: course.name)
            Membership.create!(student: @student, course: course, user: course.users.first)
  
            format.html { redirect_to students_path, notice: "Student was successfully created with course code." }
            format.json { render :show, status: :created, location: @student }
          else
            format.html { redirect_to new_student_path, alert: "Invalid course code." }
            format.json { render json: { error: "Invalid course code" }, status: :unprocessable_entity }
          end
  
        else
          format.html { redirect_to new_student_path, alert: "Please select a course or enter a course code." }
          format.json { render json: { error: "No course selected or code provided" }, status: :unprocessable_entity }
        end
      else
        format.html { render :new }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end
  
  

  # PATCH/PUT /students/1
  # PATCH/PUT /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to students_path, notice: "Student was successfully updated." }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1
  # DELETE /students/1.json
  def destroy
    respond_to do |format|
      if @student.destroy
        format.html { redirect_to students_path, notice: "Student was successfully destroyed." }
        format.json { head :no_content }
      else
        format.html { redirect_to students_url, alert: "Failed to destroy student." }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def load_courses
      @courses = Student.distinct.pluck(:course)
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
