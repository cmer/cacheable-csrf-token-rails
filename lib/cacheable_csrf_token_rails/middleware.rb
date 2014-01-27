require 'cacheable_csrf_token_rails/check_for_token_in_request'
require 'cacheable_csrf_token_rails/replace_placeholder_in_response'

module CacheableCsrfTokenRails
  class Middleware
    def initialize(app, options={})
      @app, @options = app, options
    end

    def call(env)
      check_for_token_in_request.execute(env, csrf_token(env))

      response = @app.call(env)

      token = ensure_session_has_csrf_token(env)

      replace_placeholder_in_response.execute(env, token, response)
    end

    private

    def listener
      ::CacheableCsrfTokenRails.listener
    end

    def check_for_token_in_request
      CheckForTokenInRequest.new(RequestField, TokenPlaceholder, listener)
    end

    def replace_placeholder_in_response
      ReplacePlaceholderInResponse.new(TokenPlaceholder, listener)
    end

    def csrf_token(env)
      (env['rack.session'] || {}).fetch(SessionField, nil)
    end

    def ensure_session_has_csrf_token(env)
      return unless (session = env['rack.session'])

      unless session[SessionField]
        session[SessionField] = SecureRandom.base64(32)

        listener.on_csrf_token_generated(env, session, session[SessionField])
      end

     session[SessionField]
    end
  end
end
