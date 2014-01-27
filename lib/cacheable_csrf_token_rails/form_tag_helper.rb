require 'action_view/helpers/form_tag_helper'

module ActionView::Helpers::FormTagHelper
  def token_tag(token=nil)
    if token != false && protect_against_forgery?
      tag(:input, :type => "hidden", :name => request_forgery_protection_token.to_s, :value => CacheableCsrfTokenRails::TokenPlaceholder)
    else
      ''
    end
  end
end
