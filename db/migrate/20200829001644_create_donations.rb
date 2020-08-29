class CreateDonations < ActiveRecord::Migration[5.2]
  def change
    create_table :donations do |t|
      t.references :project, null: false, foreign_key: true, index: true
      t.references :user, null: false, foreign_key: true, index: true
      t.decimal :value, null: false
      t.timestamps
    end
  end
end
