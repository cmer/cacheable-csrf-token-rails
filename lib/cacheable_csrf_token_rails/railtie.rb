
module CacheableCsrfTokenRails
  class Railtie < Rails::Railtie
    initializer "cacheable_csrf_token_rails.use_rack_middleware" do |app|
      app.config.middleware.insert 0, "CacheableCsrfTokenRails::Middleware"
    end
  end
end
