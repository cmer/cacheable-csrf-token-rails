
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
      if token = extract_token_from_env(env)
        response.body = response.body.gsub(placeholder, token)
      end

      response 
    end

    def placeholder
      ::CacheableCsrfTokenRails::TokenPlaceholder
    end

    def extract_token_from_env(env)
      env['rack.session']['_csrf_token']
    end
  end
end
