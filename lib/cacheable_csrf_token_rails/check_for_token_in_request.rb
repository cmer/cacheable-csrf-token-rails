
module CacheableCsrfTokenRails
  class CheckForTokenInRequest
    AcceptableMethods = ["POST", "PUT", "DELETE", "PATCH"]

    attr_reader :field, :placeholder, :listener

    def initialize(field, placeholder, listener)
      @field       = field
      @placeholder = placeholder
      @listener    = listener
    end

    def execute(env, expected_token)
      request = Rack::Request.new(env)

      return unless authenticatable_request?(request)

      authenticity_token = request[@field]

      if ! authenticity_token || authenticity_token == placeholder
        listener.on_token_not_in_request(field, placeholder, authenticity_token, request)
      elsif authenticity_token != expected_token
        listener.on_wrong_token_in_request(env, request, actual_token, expected_token)
      end
    end

    private
    def authenticatable_request?(request)
      AcceptableMethods.include?(request.request_method)
    end
  end
end
