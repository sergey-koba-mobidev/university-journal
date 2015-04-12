class AddKindGroupDisciplineSemesterToAttends < ActiveRecord::Migration
  def change
    add_column :attends, :kind, :integer
    add_column :attends, :group_id, :integer
    add_column :attends, :discipline_id, :integer
    add_column :attends, :semester_id, :integer
  end
end
