class RemoveCourseIdFromStudents < ActiveRecord::Migration[8.0]
  def change
    remove_reference :students, :course, foreign_key: true
  end
end
