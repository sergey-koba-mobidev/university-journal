class CreateQuestions < ActiveRecord::Migration[5.2]
  def change
    create_table :questions do |t|
      t.string :description
      t.references :question_group, index: true
      t.integer :kind
      t.string :answer
      t.jsonb :variants

      t.timestamps null: false
    end
  end
end
