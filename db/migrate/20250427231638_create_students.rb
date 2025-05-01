class CreateStudents < ActiveRecord::Migration[8.0]
  def change
    create_table 'students' do |t|
      t.string 'first_name'
      t.string 'last_name'
      t.string 'course'
      t.string 'profile_picture'
      t.timestamps
    end
  end
end
