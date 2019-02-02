class AddCheckedToStudentModules < ActiveRecord::Migration
  def change
    add_column :student_modules, :checked, :boolean
  end
end
