class CreateRecognitionRequests < ActiveRecord::Migration[8.0]
  def change
    create_table :recognition_requests do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.string :state, null: false, default: "pending"
      t.text :result

      t.timestamps
    end
  end
end
