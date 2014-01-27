
module CacheableCsrfTokenRails
  class ReplacePlaceholderInResponse
    attr_reader :placeholder, :listener

    def initialize(placeholder, listener)
      @placeholder = placeholder
      @listener    = listener
    end

    def execute(env, token, response)
      status, headers, body = response

      placeholder_found, body = replace_placeholder(token, body)

      if ! placeholder_found && response_should_include_token?(status, headers)
        listener.on_placeholder_expected_and_not_found(env, token, response)
      end

      [status, headers, body]
    end

    private

    def replace_placeholder(token, body)
      placeholder_found = false

      body.each do |part|
        placeholder_in_part = !! part.gsub!(placeholder, String(token))

        # Separate from above statement so that replacement will always run
        placeholder_found ||= placeholder_in_part
      end

      [placeholder_found, body]
    end

    def response_should_include_token?(status, headers)
      return unless String(headers['Content-Type']).include?('text/html')

      status = Integer(status || 100)

      return false if status >= 404
      return false if status < 400 && status > 299

      true
    end
  end
end
