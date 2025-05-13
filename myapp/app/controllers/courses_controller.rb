class CoursesController < ApplicationController
  before_action :set_course, only: [:show, :update, :destroy]

  def index
    @courses = Course.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @courses }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb (if needed)
      format.json {
        render json: {
          course: @course,
          students: @course.students
        }
      }
    end
  end

  # GET /courses/new
  def new
    @course = Course.new
  end

 def create
    @course = Course.new(course_params)

    respond_to do |format|
      if @course.save
        format.html { redirect_to students_path, notice: "Course was successfully created. Now add a student." }
        format.json { render json: @course, status: :created }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end
  

  def update
    if @course.update(course_params)
      render json: @course
    else
      render json: @course.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @course.destroy
    head :no_content
  end

  private

#   def set_course
#     @course = Course.find(params[:id])
#   end
  
  # Only allow a list of trusted parameters through.
  def course_params
    params.require(:course).permit(:name)
  end
end
