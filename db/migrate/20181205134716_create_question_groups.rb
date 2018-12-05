class CreateQuestionGroups < ActiveRecord::Migration
  def change
    create_table :question_groups do |t|
      t.string :title
      t.references :discipline_module, index: true
      t.integer :position

      t.timestamps null: false
    end
  end
end
