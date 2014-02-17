require "minitest/autorun"
require "rails"
require "action_view"
require "tmpl"

class Tmpl::Application < Rails::Application
  config.secret_key_base = "0000"
end

ActionView::TestCase::TestController.instance_eval do
  helper Rails.application.routes.url_helpers
end

ActionView::TestCase::TestController.class_eval do
  def _routes
    Rails.application.routes
  end
end

