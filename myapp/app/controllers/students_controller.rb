class StudentsController < ApplicationController
  before_action :authenticate_user!, except: [ :new, :create, :thank_you ]
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

    # Validate presence of first_name and last_name
    if @student.first_name.blank? || @student.last_name.blank?
      flash.now[:alert] = "First name and Last name can't be blank."
      return render :new, status: :unprocessable_entity
    end

    # Validate course selection or code
    course = nil
    if params[:course_id].present?
      begin
        course = Course.find(params[:course_id])
      rescue ActiveRecord::RecordNotFound
        flash.now[:alert] = "Selected course not found."
        return render :new, status: :unprocessable_entity
      end
    elsif params[:course_code].present?
      raw_code = params[:course_code].strip.upcase

      unless raw_code.match?(/\A[A-Z0-9]{6}\z/)
        flash.now[:alert] = "Invite code must be exactly 6 uppercase letters (A–Z) with numbers."
        return render :new, status: :unprocessable_entity
      end

      course = Course.find_by(code: raw_code)
      unless course
        flash.now[:alert] = "Invalid course code."
        return render :new, status: :unprocessable_entity
      end
    else
      flash.now[:alert] = "Please select a course or enter a course code."
      return render :new, status: :unprocessable_entity
    end

  # Only now: safe to save the student and create membership
  respond_to do |format|
    ActiveRecord::Base.transaction do
      if @student.save
        user = course.user
        puts "Creating user: #{user} for course: #{course.name}"

        Membership.create!(
          student: @student,
          course: course,
          user: user
        )
        StudentMailer.new_student_notification(@student, user, course).deliver_later
        Rails.logger.info "Sending email to #{user.email} for student #{@student.first_name} #{@student.last_name} in course #{course.name}"
        format.html { redirect_to thank_you_student_path(@student), flash: { success: "Student was successfully created." } }
        format.json { render :show, status: :created, location: @student }
      else
        flash.now[:alert] = "Failed to create student. Please ensure that you have correctly filled out each field properly."
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
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
        flash.now[:alert] = "Failed to update student. Please make sure First name and Last name are filled."
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

  def thank_you
    @student = Student.find(params[:id])
  end

  private

    def load_courses
      if user_signed_in?
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
