class StudentsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_student, only: [ :show, :edit, :update, :destroy, :confirm_destroy ]
    before_action :load_courses,  only: %i[ new edit create update ]
    # GET /students
    # GET /students.json
    def index
      @courses = Course.includes(:students).all
      @students = Student.all.with_attached_profile_picture

      respond_to do |format|
        format.html # index.html.erb view will use @courses and @students
        format.json {
          render json: @students.map { |s| student_json(s) }
        }
      end
  end

  # GET /students/1
  # GET /students/1.json
  def show
    render json: student_json(@student)
  end

  # POST /students
  # POST /students.json
  def create
    @student = Student.new(student_params)

    # Attach profile picture if provided
    if params[:profile_picture]
      @student.profile_picture.attach(params[:profile_picture])
    end

    respond_to do |format|
        if @student.save
          course = Course.find(params[:course_id])
          @student.update(course: course.name)
          Membership.create!(student: @student, course: course, user: current_user)
          format.html { redirect_to students_path, notice: "Student was successfully created." }
          format.json { render :show, status: :created, location: @student }
        else
          format.html { render :new }
          format.json { render json: @student.errors, status: :unprocessable_entity }
        end
    end
  end

  # PATCH/PUT /students/1
  # PATCH/PUT /students/1.json
  def update
    if @student.update(student_params)
      if params[:profile_picture]
        @student.profile_picture.attach(params[:profile_picture])
      end
      render json: student_json(@student)
    else
      render json: @student.errors, status: :unprocessable_entity
    end
  end

  # DELETE /students/1
  # DELETE /students/1.json
  def destroy
    @student.destroy
    head :no_content
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def student_params
      params.permit(:first_name, :last_name, :name_mastery, :learned)
    end


    def student_json(student)
      student.as_json.merge({
        profile_picture_url: student.profile_picture.attached? ? url_for(student.profile_picture) : nil
      })
    end
  
    # Never trust parameters from the scary internet, only allow the white list through.
    def student_params
      params.require(:student).permit(:first_name, :last_name, :profile_picture, :course)
    end

end
