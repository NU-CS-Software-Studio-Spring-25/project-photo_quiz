# CoursesController manages course-related actions including creation, update, and deletion.
class CoursesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_course, only: %i[ show edit update destroy ]

  # GET /courses or /courses.json
  def index
    @courses = current_user.courses.includes(:students).distinct
  end

  # GET /courses/1 or /courses/1.json
  def show
    @students = @course.students
  end

  # GET /courses/new
  def new
    @course = Course.new
  end

  # GET /courses/1/edit
  def edit
    # @course already set by set_course
  end

  # POST /courses or /courses.json
  def create
    @course = current_user.owned_courses.build(course_params)

    respond_to do |format|
      if @course.save
        respond_success(format, "Course was successfully created. Now add a student for it to appear on Dashboard.", @course)
      else
        respond_failure(format, :new, @course)
      end
    end
  end

  # PATCH/PUT /courses/1 or /courses/1.json
  def update
    respond_to do |format|
      if @course.update(course_params)
        respond_success(format, "Course was successfully updated.", @course)
      else
        respond_failure(format, :edit, @course)
      end
    end
  end

  # DELETE /courses/1 or /courses/1.json
  def destroy
    @course.destroy!
    respond_to_destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_course
      @course = Course.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def course_params
      params.require(:course).permit(:name)
    end

    # Responds with success and a message for HTML and JSON formats.
    def respond_success(format, message, course)
      format.html { redirect_to students_path, flash: { success: message } }
      format.json { render :show, status: :ok, location: course }
    end

    # Responds with failure and renders the action for HTML and JSON formats.
    def respond_failure(format, action, course)
      format.html { render action, status: :unprocessable_entity }
      format.json { render json: course.errors, status: :unprocessable_entity }
    end

    # Responds to the destroy action with a redirect or no content based on the format.
    def respond_to_destroy
      respond_to do |format|
        format.html { redirect_to students_path, status: :see_other, flash: { success: "Course was successfully destroyed." } }
        format.json { head :no_content }
      end
    end
end
