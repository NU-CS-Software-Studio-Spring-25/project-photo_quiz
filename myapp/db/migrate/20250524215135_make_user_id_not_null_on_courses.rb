class MakeUserIdNotNullOnCourses < ActiveRecord::Migration[8.0]
  def change
    change_column_null :courses, :user_id, false
  end
end
