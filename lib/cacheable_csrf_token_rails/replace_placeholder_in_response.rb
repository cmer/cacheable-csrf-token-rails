
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

      unless placeholder_found
        listener.on_placeholder_not_found(env, token, response)
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
  end
end
