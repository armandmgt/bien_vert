class AddDiedAtToPlants < ActiveRecord::Migration[8.1]
  def change
    add_column :plants, :died_at, :datetime
  end
end
