
module CacheableCsrfTokenRails
  class Railtie < Rails::Railtie
    initializer "cacheable_csrf_token_rails.use_rack_middleware" do |app|
      app.config.middleware.insert_after "Rack::ETag", "::CacheableCsrfTokenRails::Middleware"
    end
  end
end
