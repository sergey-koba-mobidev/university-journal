class AddVisitToHomework < ActiveRecord::Migration
  def change
    add_reference :homeworks, :visit, index: true
    add_reference :homeworks, :user, index: true
    add_foreign_key :homeworks, :visits
    add_column :homeworks, :body, :text

    remove_reference :homeworks, :attend
  end
end
