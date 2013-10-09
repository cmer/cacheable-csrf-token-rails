
module CacheableCsrfTokenRails
  module Controller
    def self.included(base)
      base.class_eval do
        prepend_before_filter :form_authenticity_token
      end
    end
  end

  ::ActionController::Base.send(:include, Controller)
end
