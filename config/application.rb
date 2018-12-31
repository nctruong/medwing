require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
Dotenv::Railtie.load

module Medwing
  class Application < Rails::Application
    config.load_defaults 5.1
    config.active_job.queue_adapter = :sneakers
    config.enable_dependency_loading = true
    # config.autoload_paths << Rails.root.join('app/services')
    config.api_only = true
  end
end

# conn = Bunny.new
# conn.start
# publish_channel = conn.create_channel
# $post_queue = publish_channel.queue('readings.create', durable: true)
#
# $delayed_exchange = Bunny::Exchange.new(publish_channel, 'x-delayed-message', 'delayed.exchange', {
#     type: 'x-delayed-message',
#     arguments: { 'x-delayed-type' => 'direct' },
#     durable: true,
#     auto_delete: false
# })