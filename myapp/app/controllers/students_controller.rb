class StudentsController < ApplicationController
  before_action :authenticate_user!, except: [:new]
  before_action :set_student, only: [ :show, :edit, :update, :destroy, :confirm_destroy ]
  before_action :load_courses, only: %i[new edit create update]
  
  # GET /students
  # GET /students.json
  def index
    @courses = current_user.courses.includes(:students).distinct
    @students = current_user.students
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
            Membership.create!(student: @student, course: course, user: current_user)
  
            format.html { redirect_to students_path, flash: { success: "Student was successfully created." } }
            format.json { render :show, status: :created, location: @student }
          rescue ActiveRecord::RecordNotFound
            flash.now[:alert] = "Selected course not found."
            format.html { render :new }
            format.json { render json: { error: "Course not found" }, status: :unprocessable_entity }
          end
        else
          flash.now[:alert] = "Please select a course."
          format.html { render :new }
          format.json { render json: { error: "No course selected" }, status: :unprocessable_entity }
        end
      else
        flash.now[:alert] = "Failed to create student. Please make sure First name, Last name, and Course are filled."
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
        format.html { redirect_to students_path, flash: {success: "Student was successfully updated."} }
        format.json { render :show, status: :ok, location: @student }
      else
        flash.now[:alert] = "Failed to update student. Please make sure First name, Last name, and Course are filled."
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
        format.html { redirect_to students_path, flash: {success: "Student was successfully destroyed."} }
        format.json { head :no_content }
      else
        flash.now[:alert] = "Failed to destroy student. Please try again."
        format.html { redirect_to students_url, alert: "Failed to destroy student." }
        format.json { render json: @student.errors, status: :unprocessable_entity }
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
