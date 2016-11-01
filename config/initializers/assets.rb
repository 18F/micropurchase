Rails.application.config.assets.version = (ENV["ASSETS_VERSION"] || "1.0")
Rails.application.config.assets.precompile += %w( jquery.js admin.js )
Rails.application.config.assets.precompile += %w( uswds/us_flag_small.png )
