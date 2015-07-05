class AddVisitToHomework < ActiveRecord::Migration
  def change
    add_reference :homeworks, :visit, index: true
    add_reference :homeworks, :user, index: true
    add_foreign_key :homeworks, :visits

    remove_reference :homeworks, :attend
  end
end
