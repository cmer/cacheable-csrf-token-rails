
module CacheableCsrfTokenRails
  class CheckForTokenInRequest
    AcceptableMethods = ["POST", "PUT", "DELETE", "PATCH"]

    attr_reader :field, :placeholder, :listener

    def initialize(field, placeholder, listener)
      @field       = field
      @placeholder = placeholder
      @listener    = listener
    end

    def execute(env)
      request = Rack::Request.new(env)

      return unless authenticatable_request?(request)

      authenticity_token = request[@field]

      if ! authenticity_token || authenticity_token == placeholder
        listener.on_token_not_in_request(field, placeholder, authenticity_token, request)
      end
    end

    private
    def authenticatable_request?(request)
      AcceptableMethods.include?(request.request_method)
    end
  end
end
