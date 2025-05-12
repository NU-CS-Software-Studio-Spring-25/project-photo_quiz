class StudentsController < ApplicationController
  before_action :set_student, only: [ :show, :update, :destroy ]

  # GET /students
  # GET /students.json
  def index
    @students = Student.all.with_attached_profile_picture
    render json: @students.map { |s| student_json(s) }
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

    if @student.save
      render json: student_json(@student), status: :created
    else
      render json: @student.errors, status: :unprocessable_entity
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
end
