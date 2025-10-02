# frozen_string_literal: true

module Hotwire
  class ConfigurationsController < ApplicationController
    allow_unauthenticated_access

    def ios
      render json: {
        settings: {},
        rules: [
          {
            patterns: [
              ".*"
            ],
            properties: {
              context: "default",
              pull_to_refresh_enabled: true
            }
          },
          {
            patterns: [ new_session_path ],
            properties: {
              view_controller: "sign_out"
            }
          }
        ]
      }
    end

    def android
      render json: {
        settings: {},
        rules: [
          {
            patterns: [
              ".*"
            ],
            properties: {
              context: "default",
              pull_to_refresh_enabled: true
            }
          }
        ]
      }
    end
  end
end
