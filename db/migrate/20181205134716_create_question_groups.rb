class CreateQuestionGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :question_groups do |t|
      t.string :title
      t.references :discipline_module, index: true
      t.integer :position
      t.integer :points

      t.timestamps null: false
    end
  end
end
