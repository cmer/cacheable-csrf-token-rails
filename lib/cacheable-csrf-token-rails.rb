# Inspired from http://www.jarrodspillers.com/2010/02/06/trying-to-use-rails-csrf-protection-on-cached-actions-rack-middleware-to-the-rescue/ and https://gist.github.com/1124982/632f1fcbe0981424128b3088ddb27a322c369cc1

module CacheableCSRFTokenRails
  def self.included(base)

    ApplicationController.const_set "TOKEN_PLACEHOLDER", "__CROSS_SITE_REQUEST_FORGERY_PROTECTION_TOKEN__"
    base.class_eval do
      after_filter  :inject_csrf_token

      private
      def inject_csrf_token
        if protect_against_forgery? && token = form_authenticity_token
          if body_with_token = response.body.gsub!(ApplicationController::TOKEN_PLACEHOLDER, token)
            response.body = body_with_token
          end
        end
      end
    end

    token_tag_helper = (Rails::VERSION::MAJOR >= 4) ? ActionView::Helpers::UrlHelper : ActionView::Helpers::FormTagHelper

    token_tag_helper.class_eval do
      alias_method :token_tag_rails, :token_tag

      def token_tag(token=nil)
        if token != false && protect_against_forgery?
          tag(:input, :type => "hidden", :name => request_forgery_protection_token.to_s, :value => ApplicationController::TOKEN_PLACEHOLDER)
        else
          ''
        end
      end
    end

    ActionView::Helpers::CsrfHelper.class_eval do
      def csrf_meta_tags
        if protect_against_forgery?
          [
            tag('meta', :name => 'csrf-param', :content => request_forgery_protection_token),
            tag('meta', :name => 'csrf-token', :content => ApplicationController::TOKEN_PLACEHOLDER)
          ].join("\n").html_safe
        end
      end
    end

  end # included
end
