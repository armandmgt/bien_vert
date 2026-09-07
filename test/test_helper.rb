ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

Rails.application.load_seed

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Each parallel worker loads the schema into its own database, which drops
    # the seed data loaded above, so seed every worker too.
    parallelize_setup do
      Rails.application.load_seed
    end

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    def login(user, password = "password")
      post session_path, params: { user: { email_address: user.email_address, password: password } }
    end
  end
end
