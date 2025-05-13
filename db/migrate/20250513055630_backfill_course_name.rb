class BackfillCourseName < ActiveRecord::Migration[8.0]
  def up
    Course.reset_column_information
    Course.find_each { |c| c.update_column(:name, c.title) }
  end
  def down
    # no-op
  end
end