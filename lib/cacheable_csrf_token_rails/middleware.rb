
module CacheableCsrfTokenRails
  class Middleware

    def initialize(app, options={})
      @app, @options = app, options
    end

    def call(env)
      status, headers, response = @app.call(env)

      [status, headers, replace_token_in_body(response, env)]
    end

    private

    def replace_token_in_body(response, env)
      is_mappable = response.respond_to?(:map)
      token       = extract_token_from_env(env)

      if is_mappable && token
        response.map { |b| b.gsub(placeholder, token) }
      else
        logger.log lib: :cacheable_csrf_token_rails, at: :token_not_replaced, request_uri: env['REQUEST_URI'], response_enumerable: is_mappable, token: token
        response
      end
    end

    def placeholder
      ::CacheableCsrfTokenRails::TokenPlaceholder
    end

    def extract_token_from_env(env)
      (env['rack.session'] || {})['_csrf_token']
    end

    def logger
      ::CacheableCsrfTokenRails.logger
    end
  end
end
