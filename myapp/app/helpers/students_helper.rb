# Helper methods for students
module StudentsHelper
  def group_students(students)
    students.group_by { |student| student.courses.first }
  end

  def build_query_conditions(query_words)
    student_conditions = query_words.map.with_index { |_, index| "(LOWER(students.first_name) LIKE :w#{index} OR LOWER(students.last_name) LIKE :w#{index})" }.join(" AND ")
    course_conditions = query_words.map.with_index { |_, index| "LOWER(courses.name) LIKE :w#{index}" }.join(" OR ")
    query_params = query_words.each_with_index.to_h { |word, index| ["w#{index}".to_sym, "%#{word}%"] }
    [student_conditions, course_conditions, query_params]
  end

  def handle_course_assignment(format)
    if params[:course_id].present?
      assign_by_course_id(format)
    elsif params[:course_code].present?
      assign_by_course_code(format)
    else
      respond_with_error(format, { error: "No course selected or code provided" }, "Please select a course or enter a course code.", :unprocessable_entity)
    end
  end

  def assign_by_course_id(format)
    course = Course.find_by(id: params[:course_id])

    if course
      Membership.create!(student: @student, course: course, user: current_user)
      respond_with_success(format, "Student was successfully created.")
    else
      respond_with_error(format, { error: "Course not found" }, "Selected course not found.")
    end
  end

  def assign_by_course_code(format)
    course = Course.find_by(code: params[:course_code].strip.upcase)

    if course
      @student.update(course: course.name)
      Membership.create!(student: @student, course: course, user: course.users.first)
      respond_with_success(format, "Student was successfully created with course code.", :notice)
    else
      respond_with_error(format, { error: "Invalid course code" }, "Invalid course code.")
    end
  end

  def respond_with_success(format, message, flash_type = :success)
    format.html { redirect_to students_path, flash: { flash_type => message } }
    format.json { render :show, status: :created, location: @student }
  end

  def respond_with_error(format, json_error, flash_message, status = :unprocessable_entity)
    flash.now[:alert] = flash_message
    format.html { render :new, status: status }
    format.json { render json: json_error, status: status }
  end

  def respond_to_destroy(format, message)
    format.html { redirect_to students_url, status: :see_other, flash: {success: message} }
    format.json { head :no_content }
  rescue ActiveRecord::RecordNotDestroyed => error
    respond_with_error(format, { error: error.message }, "Failed to destroy student.")
  end
end