class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.decimal :goal, null: false
      t.date :closing_date, null: false
      t.references :user, null: false, foreign_key: true, index: true
      t.timestamps
    end
  end
end
