class StudentsController < ApplicationController
  before_action :authenticate_user!, except: [ :new ]
  before_action :set_student, only: [ :show, :edit, :update, :destroy, :confirm_destroy ]
  before_action :load_courses, only: %i[new edit create update]

  # GET /students
  # GET /students.json
  def index
    students_scope = current_user.students.includes(:courses).distinct
    courses_scope = current_user.courses.includes(:students).distinct

    if params[:query].present?
      query = params[:query].downcase.strip
      query_words = query.split

      student_conditions = query_words.map.with_index do |_, i|
        "(LOWER(students.first_name) LIKE :w#{i} OR LOWER(students.last_name) LIKE :w#{i})"
      end.join(" AND ")

      course_conditions = query_words.map.with_index do |_, i|
        "LOWER(courses.name) LIKE :w#{i}"
      end.join(" OR ")

      query_params = {}
      query_words.each_with_index { |word, i| query_params[:"w#{i}"] = "%#{word}%" }

      # Combine student and course search in one query
      students_filtered = students_scope
        .left_outer_joins(:courses)
        .where("#{student_conditions} OR #{course_conditions}", **query_params)
        .distinct

      @students = students_filtered.page(params[:page]).per(50)
      @students_grouped = @students.group_by { |student| student.courses.first }
      @courses = courses_scope.where(id: students_filtered.joins(:courses).select("courses.id"))
    else
      @students = students_scope.page(params[:page]).per(20)
      @students_grouped = @students.group_by { |student| student.courses.first }
      @courses = courses_scope
    end
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

        elsif params[:course_code].present?
          raw_code = params[:course_code].strip.upcase

          unless raw_code.match?(/\A[A-Z]{6}\z/)
            flash.now[:alert] = "Invite code must be exactly 6 uppercase letters (A–Z)."
            format.html { render :new, status: :unprocessable_entity }
            format.json { render json: { error: "Invalid code format" }, status: :unprocessable_entity }
            return
          end
          course = Course.find_by(code: params[:course_code].strip.upcase)

          if course
            @student.update(course: course.name)
            Membership.create!(student: @student, course: course, user: course.users.first)

            format.html { redirect_to students_path, flash: { notice: "Student was successfully created with course code." } }
            format.json { render :show, status: :created, location: @student }
          else
            flash.now[:alert] = "Invalid course code."
            format.html { render :new }
            format.json { render json: { error: "Invalid course code" }, status: :unprocessable_entity }
          end
        else
          flash.now[:alert] = "Please select a course or enter a course code."
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: { error: "No course selected or code provided" }, status: :unprocessable_entity }
        end
      else
        flash.now[:alert] = "Failed to create student. Please make sure First name, Last name, and Course are filled."
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /students/1
  # PATCH/PUT /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to students_path, flash: { success: "Student was successfully updated." } }
        format.json { render :show, status: :ok, location: @student }
      else
        flash.now[:alert] = "Failed to update student. Please make sure First name, Last name, and Course are filled."
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1
  # DELETE /students/1.json
  def destroy
    respond_to do |format|
      if @student.destroy
        format.html { redirect_to students_path, flash: { success: "Student was successfully destroyed." } }
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
      if current_user
        @courses = current_user.owned_courses
      elsif params[:course_code].present?
        course = Course.find_by(code: params[:course_code].strip.upcase)
        @courses = course ? [course] : []
      else
        @courses = []
      end
    end

    def set_student
      @student = Student.find(params[:id])
    end

    def student_params
      params.require(:student).permit(:first_name, :last_name, :profile_picture)
    end
end
