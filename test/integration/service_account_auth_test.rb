require "test_helper"

class ServiceAccountAuthTest < ActionDispatch::IntegrationTest
  # The admin namespace holds nothing but the production-only Solid Errors mount, so there
  # is no real admin route to exercise here. This stands in for one: it inherits the same
  # base controller, so it runs exactly the authentication and authorization filters the
  # dashboard runs.
  class ProbesController < Admin::AdminController
    def show
      render plain: "ok"
    end
  end

  setup do
    # A service account has no user behind it; access is granted purely by the
    # service-account session, exercising the token auth path specifically.
    @session = Session.create!(service_account: true)
    @token = @session.generate_token_for(:service_account_api)
  end

  test "bearer token for a service account is authorized in the admin namespace" do
    with_admin_probe do
      get "/admin/probe", headers: { "Authorization" => "Bearer #{@token}" }
      assert_response :success
    end
  end

  test "an admin user is authorized in the admin namespace" do
    with_admin_probe do
      login users(:admin)
      get "/admin/probe"
      assert_response :success
    end
  end

  test "a signed-in non-admin is turned away" do
    with_admin_probe do
      login users(:one)
      get "/admin/probe"
      assert_redirected_to root_path
    end
  end

  test "request without a token is not authorized" do
    with_admin_probe do
      get "/admin/probe"
      assert_redirected_to new_session_path
    end
  end

  test "invalid bearer token is not authorized" do
    with_admin_probe do
      get "/admin/probe", headers: { "Authorization" => "Bearer not-a-real-token" }
      assert_redirected_to new_session_path
    end
  end

  test "token minted from a non-service-account session is rejected" do
    # The token is only as good as the flag on the session it came from — otherwise any
    # signed-in user could mint themselves API access.
    token = users(:one).sessions.create!.generate_token_for(:service_account_api)

    with_admin_probe do
      get "/admin/probe", headers: { "Authorization" => "Bearer #{token}" }
      assert_redirected_to new_session_path
    end
  end

  test "token no longer works once the service-account session is destroyed" do
    @session.destroy

    with_admin_probe do
      get "/admin/probe", headers: { "Authorization" => "Bearer #{@token}" }
      assert_redirected_to new_session_path
    end
  end

  test "a service-account token is not accepted outside the admin namespace" do
    # Bearer auth is deliberately scoped to Admin::AdminController; everywhere else a
    # session still means a person with a cookie.
    get root_path, headers: { "Authorization" => "Bearer #{@token}" }
    assert_redirected_to new_session_path
  end

  test "a service account session is valid without a user" do
    assert Session.new(service_account: true).valid?
  end

  test "an ordinary session still requires a user" do
    assert_not Session.new.valid?
  end

  private

  # with_routing swaps the whole route set, so the paths the filters redirect to have to be
  # redrawn alongside the probe.
  def with_admin_probe
    with_routing do |set|
      set.draw do
        root "plants#index"
        resource :session, only: [ :new, :create ]
        # Drawn as a plain path rather than inside `namespace :admin`, which would look for
        # the controller under Admin::. What gates the request is the base controller it
        # inherits, not where the route sits.
        get "/admin/probe", to: "service_account_auth_test/probes#show"
      end
      yield
    end
  end
end
