
module CacheableCsrfTokenRails
  class Railtie < Rails::Railtie
    initializer "cacheable_csrf_token_rails.configure_rails_initialization" do |app|
      app.middleware.use ::CacheableCsrfTokenRails::Middleware
    end
  end
end
