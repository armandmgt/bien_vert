class PushSubscriptionsController < ApplicationController
  def vapid_key
    render plain: JSON.parse(Rpush::Webpush::App.find_by!(name: "webpush").certificate)["public_key"]
  end

  def create
    Current.user.find_or_add_subscription(create_params)
    if Current.user.save
      head :ok
    else
      head :unprocessable_content
    end
  end

  private

  def create_params
    params.expect push_subscription: [
      :platform,

      # For APNs subscriptions
      :deviceToken,

      # For Web Push subscriptions
      :endpoint,
      :expirationTime,
      { keys: [ :p256dh, :auth ] }
    ]
  end
end
