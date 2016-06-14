Rails.application.config.assets.version = (ENV["ASSETS_VERSION"] || "1.0")
Rails.application.config.assets.precompile += %w( jquery.js )
Rails.application.config.assets.paths << Rails.root.join('app', 'assets', 'fonts')
