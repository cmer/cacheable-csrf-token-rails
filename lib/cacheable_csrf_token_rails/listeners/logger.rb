
module CacheableCsrfTokenRails
  module Listeners
    class Logger
      attr_reader :logger

      def initialize(logger)
        @logger = logger
      end

      def on_csrf_token_generated(env, session, token)
        logger.debug %Q{lib=cacheable_csrf_token_rails at=on_csrf_token_generated new_token="#{token}"}
      end

      def on_placeholder_expected_and_not_found(env, token, response)
        status, _, body = response

        logger.info %Q{lib=cacheable_csrf_token_rails at=token_not_replaced uri="#{env['REQUEST_URI']}" status=#{status} body_eachable?=#{body.respond_to?(:each)} token="#{token}"}
      end

      def on_token_not_in_request(field, placeholder, token, request)
        logger.error %{lib=cacheable_csrf_token_rails at=token_not_in_request_body expected_token="#{token}"}
      end

      def on_wrong_token_in_request(env, request, actual_token, expected_token)
        logger.error %Q{lib=cacheable_csrf_token_rails at=wrong_token_in_request expected_token=#{expected_token} actual_token=#{actual_token}}
      end

      def method_missing(*args, &block)
        logger.error %Q{lib=cacheable_csrf_token_rails at=method_missing method=#{args.first}}
      end
    end
  end
end
