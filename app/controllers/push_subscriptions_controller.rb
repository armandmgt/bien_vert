class PushSubscriptionsController < ApplicationController
  def vapid_key
    render plain: JSON.parse(Rpush::Webpush::App.find_by!(name: "webpush").certificate)["public_key"]
  end

  def create
    Current.user.subscriptions << create_params
    if Current.user.save
      head :ok
    else
      head :unprocessable_entity
    end
  end

  def destroy
  end

  private

  def create_params
    params.expect push_subscription: [ :endpoint, :expirationTime, { keys: [ :p256dh, :auth ] } ]
  end
end
