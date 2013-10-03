
module CacheableCsrfTokenRails
  class Middleware

    def initialize(app, options={})
      @app, @options = app, options
    end

    def call(env)
      replace_token(*[env].concat(@app.call(env)))
    end

    private

    def replace_token(env, status, headers, body)
      is_mappable = body.respond_to?(:map)
      token       = extract_token_from_env(env)

      if is_mappable && token
        body.map! { |b| b.gsub(placeholder, token) }
      elsif String(headers['Content-Type']).include?('text/html')
        logger.log(
          lib: :cacheable_csrf_token_rails,
          at: :token_not_replaced,
          request_uri: env['REQUEST_URI'],
          response_enumerable: is_mappable,
          token: token
        )
      end

      [status, headers, body]
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
