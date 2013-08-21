# Inspired from http://www.jarrodspillers.com/2010/02/06/trying-to-use-rails-csrf-protection-on-cached-actions-rack-middleware-to-the-rescue/ and https://gist.github.com/1124982/632f1fcbe0981424128b3088ddb27a322c369cc1

module CacheableCsrfTokenRails
  TokenPlaceholder = "__CROSS_SITE_REQUEST_FORGERY_PROTECTION_TOKEN__"
end

require 'cacheable_csrf_token_rails/middleware'

if defined?(Rails)
  require 'cacheable_csrf_token_rails/controller'
  require 'cacheable_csrf_token_rails/form_tag_helper'
  require 'cacheable_csrf_token_rails/csrf_helper'
  require 'cacheable_csrf_token_rails/railtie'
end
