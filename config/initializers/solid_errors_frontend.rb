# Be sure to restart your server when you modify this file.

# The ingest endpoint deliberately does not inherit from ApplicationController -- it has
# to stay reachable without a session so errors on the sign-in page are captured too.
# That means the Authentication concern never runs and Current.session is unset, so the
# user is resolved straight from the signed cookie instead (same lookup as
# Authentication#find_session_by_cookie). The lambda is instance_exec'd in the
# controller, which is what gives it `cookies`.
#
# `user_id` matches the context key Authentication already attaches to server-side
# errors, so browser and server reports read the same way in the dashboard.
SolidErrors::Frontend.context = -> {
  session_id = cookies.signed[:session_id]
  { user_id: session_id && Session.where(id: session_id).pick(:user_id) }
}
