require 'action_view/helpers/csrf_helper'

module ActionView::Helpers::CsrfHelper
  def csrf_meta_tags
    if protect_against_forgery?
      [
        tag('meta', :name => 'csrf-param', :content => request_forgery_protection_token),
        tag('meta', :name => 'csrf-token', :content => ::CacheableCsrfTokenRails::TokenPlaceholder)
      ].join("\n").html_safe
    end
  end
end
