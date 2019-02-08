class AddRightAnswersToStudentModules < ActiveRecord::Migration
  def change
    add_column :student_modules, :right_answers, :jsonb
  end
end
