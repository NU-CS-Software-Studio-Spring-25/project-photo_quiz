class RenameTitleToNameInCourses < ActiveRecord::Migration[8.0]
  def change
    rename_column :courses, :title, :name
  end
end
