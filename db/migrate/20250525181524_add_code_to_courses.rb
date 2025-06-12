class AddCodeToCourses < ActiveRecord::Migration[8.0]
  def change
    add_column :courses, :code, :string
  end
end
