
module CacheableCsrfTokenRails
  module Listeners
    class Null
      def method_missing(*args, &block)
        nil
      end
    end
  end
end
