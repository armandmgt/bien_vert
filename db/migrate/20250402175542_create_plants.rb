class CreatePlants < ActiveRecord::Migration[8.0]
  def change
    create_table :plants do |t|
      t.belongs_to :user, foreign_key: true, null: false

      t.string :species, null: false
      t.string :name
      t.decimal :watering_interval_days, null: false
      t.datetime :last_watered_at

      t.timestamps
    end
  end
end
