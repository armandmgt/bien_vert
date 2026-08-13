source "https://rubygems.org"

gem "bcrypt"
gem "bootsnap", require: false
gem "hotwire-spark"
gem "image_processing"
gem "importmap-rails"
gem "jbuilder"
gem "kamal", require: false
gem "lucide-rails"
gem "propshaft"
gem "puma"
gem "rails"
gem "rpush"
gem "ruby-openai"
gem "ruby-vips", "~> 2.0"
gem "solid_cable"
gem "solid_cache"
gem "solid_errors", group: :production
# Not production-only, unlike solid_errors itself: it reports through Rails.error,
# so in dev the browser errors it catches still surface in the log.
gem "solid_errors-frontend", "~> 0.1"
gem "solid_queue"
gem "sqlite3", ">= 2.1"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "tailwind_merge"
gem "thruster", require: false
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "web-push"

group :development, :test do
  gem "brakeman", require: false
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
