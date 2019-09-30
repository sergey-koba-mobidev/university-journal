class AddRightAnswersToStudentModules < ActiveRecord::Migration[5.2]
  def change
    add_column :student_modules, :right_answers, :jsonb
  end
end
