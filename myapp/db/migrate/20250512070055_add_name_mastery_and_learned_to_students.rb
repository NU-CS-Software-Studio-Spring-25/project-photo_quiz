class AddNameMasteryAndLearnedToStudents < ActiveRecord::Migration[8.0]
  def change
    add_column :students, :name_mastery, :integer
    add_column :students, :learned, :boolean
  end
end
