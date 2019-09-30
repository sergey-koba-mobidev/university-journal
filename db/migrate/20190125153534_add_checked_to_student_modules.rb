class AddCheckedToStudentModules < ActiveRecord::Migration[5.2]
  def change
    add_column :student_modules, :checked, :boolean
  end
end
