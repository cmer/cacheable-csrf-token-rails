require 'cacheable_csrf_token_rails/check_for_token_in_request'
require 'cacheable_csrf_token_rails/replace_placeholder_in_response'

module CacheableCsrfTokenRails
  class Middleware
    def initialize(app, options={})
      @app, @options = app, options
    end

    def call(env)
      check_for_token_in_request.execute(env)

      replace_placeholder_in_response.execute(env, token_from_env(env), @app.call(env))
    end

    def on_placeholder_not_found(env, token, response)
      status, headers, body = response

      return unless String(headers['Content-Type']).include?('text/html')
      return unless Integer(status || 100) < 300

      logger.log(
        lib: :cacheable_csrf_token_rails,
        at: :token_not_replaced,
        request_uri: env['REQUEST_URI'],
        status: status,
        body_eachable?: body.respond_to?(:each),
        token: token
      )
    end

    def on_token_not_in_request(field, placeholder, token, request)
      logger.log(
        lib: :cacheable_csrf_token_rails,
        at:  :token_not_in_request_body,
        authenticity_token: request['authenticity_token'],
      )
    end

    private

    def check_for_token_in_request
      @check_for_token_in_request ||= CheckForTokenInRequest.new(
        'authenticity_token',
        ::CacheableCsrfTokenRails::TokenPlaceholder,
        self
      )
    end

    def replace_placeholder_in_response
      @replacer ||= ReplacePlaceholderInResponse.new(
        ::CacheableCsrfTokenRails::TokenPlaceholder,
        self
      )
    end

    def token_from_env(env)
      (env['rack.session'] || {})['_csrf_token']
    end

    def logger
      ::CacheableCsrfTokenRails.logger
    end
  end
end
