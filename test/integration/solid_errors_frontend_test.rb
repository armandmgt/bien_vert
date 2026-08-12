require "test_helper"

# The gem has its own suite for parsing, stack rewriting and endpoint limits. What's left
# to test here is our wiring: the context lambda in
# config/initializers/solid_errors_frontend.rb, which resolves identity from the session
# cookie because the ingest controller never runs the Authentication concern.
class SolidErrorsFrontendTest < ActionDispatch::IntegrationTest
  test "attaches the signed-in user to the report" do
    user = users(:one)
    login user

    report = assert_error_reported(SolidErrors::Frontend::BrowserError) do
      post_reports [ { name: "TypeError", message: "boom", source: "window" } ]
    end

    assert_response :no_content
    assert_equal user.id, report.context[:user_id]
  end

  # Errors on the sign-in and sign-up pages are the ones we'd otherwise never hear about,
  # so a missing session must not stop a report.
  test "records a report made without a session" do
    report = assert_error_reported(SolidErrors::Frontend::BrowserError) do
      post_reports [ { name: "Error", message: "boom on the sign-in page", source: "window" } ]
    end

    assert_response :no_content
    assert_nil report.context[:user_id]
  end

  # The endpoint is unauthenticated, so this is the one that matters: a client must not be
  # able to attribute its errors to somebody else.
  test "a client cannot spoof the user" do
    login users(:one)

    report = assert_error_reported(SolidErrors::Frontend::BrowserError) do
      post_reports [ { message: "boom", context: { user_id: users(:two).id } } ]
    end

    assert_equal users(:one).id, report.context[:user_id]
  end

  test "the layout advertises the ingest endpoint to the browser" do
    get new_session_path

    meta = Nokogiri::HTML(response.body).at_css("meta[name='solid-errors-frontend']")
    assert meta, "the layout must render frontend_errors_tag"
    assert_equal solid_errors_frontend.reports_path, JSON.parse(meta["content"])["endpoint"]
  end

  private
    def post_reports(reports, headers: {})
      post solid_errors_frontend.reports_path,
           params: { reports: reports }.to_json,
           headers: { "CONTENT_TYPE" => "application/json" }.merge(headers)
    end
end
