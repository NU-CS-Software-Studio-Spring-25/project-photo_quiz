class RemoveUserIdFromCourses < ActiveRecord::Migration[8.0]
  def change
    remove_column :courses, :user_id, :integer
  end
end
