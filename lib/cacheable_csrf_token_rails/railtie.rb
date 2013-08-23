
module CacheableCsrfTokenRails
  class Railtie < Rails::Railtie
    initializer "cacheable_csrf_token_rails.configure_rails_initialization" do |app|
      app.middleware.insert_after ::ActionDispatch::ParamsParser, ::CacheableCsrfTokenRails::Middleware
    end
  end
end
