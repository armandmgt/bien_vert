class AddSubscriptionsToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :subscriptions, :text, null: false, default: "[]"
  end
end
