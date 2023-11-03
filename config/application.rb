require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

CONFIG = YAML.load(File.read(File.expand_path('../application.yml', __FILE__)))
CONFIG.merge! CONFIG.fetch(Rails.env, {})
CONFIG.symbolize_keys!

constant_hash = Dir.glob(File.join('config/constants', '*.yml')).reduce({}) do |hash, file_path|
  hash.merge(YAML.load_file(file_path))
end
APP_CONSTANTS = JSON.parse(constant_hash.to_json, object_class:OpenStruct)

module Bkeeper
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = "Eastern Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
      html_tag.gsub("form-control", "form-control is-invalid").html_safe      
    end    
  end
end
