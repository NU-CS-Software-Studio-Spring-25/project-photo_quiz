class AddNameToCourses < ActiveRecord::Migration[8.0]
  disable_ddl_transaction!   # safe index concurrently
  def change
    add_column :courses, :name, :string
    add_index  :courses, :name, algorithm: :concurrently
  end
end