class StudentsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_student, only: [ :show, :edit, :update, :destroy, :confirm_destroy ]
    before_action :load_courses,  only: %i[ new edit create update ]
    # GET /students
    # GET /students.json
    def index
      @student = Student.all
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
        params.require(:student).permit(:first_name, :last_name, :course, :profile_picture)
      end
end
