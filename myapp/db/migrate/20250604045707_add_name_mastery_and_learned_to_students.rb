class AddNameMasteryAndLearnedToStudents < ActiveRecord::Migration[8.0]
  def change
    add_column :students, :name_mastery, :integer, default: 0, null: false
    add_column :students, :learned, :boolean, default: false, null: false
  end
end
