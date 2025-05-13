class RemoveFieldsFromStudents < ActiveRecord::Migration[8.0]
  def change
    remove_column :students, :profile_picture, :string
    remove_column :students, :course, :string
  end
end
