class ChangeCourseIdNullConstraintOnStudents < ActiveRecord::Migration[8.0]
  def up
    Student.where(course_id: nil).destroy_all
    change_column_null :students, :course_id, false
  end

  def down
    change_column_null :students, :course_id, true
  end
end
