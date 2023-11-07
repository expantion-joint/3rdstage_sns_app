require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Src
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    
    # 追加：デフォルトのlocaleを日本語(:ja)にする
    config.i18n.default_locale = :ja
    # 追加：タイムゾーンを日本に変更
    config.time_zone = 'Tokyo'
    # 追加：バッチファイルを実行（config/lib/batch/data_create.rbを実行）
    config.paths.add 'lib', eager_load: true

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
