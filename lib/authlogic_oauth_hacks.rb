# From http://github.com/jrallison/authlogic_oauth/issuesearch?state=open&q=nil.params#issue/2

# Replace following in lib/authlogic_oauth.rb.
# See: http://github.com/jrallison/authlogic_oauth/issues/#issue/3
# 
#  if defined?(Authlogic) # Fixes "undefined method `acts_as_authentic_config'" error when using rake.
#    ActiveRecord::Base.send(:include, AuthlogicOauth::ActsAsAuthentic)
#    Authlogic::Session::Base.send(:include, AuthlogicOauth::Session)
#    ActionController::Base.helper AuthlogicOauth::Helper
#  end

module AuthlogicOauth
  module ActsAsAuthentic
    module Methods

      # Fixes issue. See: http://github.com/jrallison/authlogic_oauth/issues/#issue/2
      def authenticating_with_oauth?
        if session_class.controller
          # Initial request when user presses one of the button helpers
          (session_class.controller.params && !session_class.controller.params[:register_with_oauth].blank?) ||
          # When the oauth provider responds and we made the initial request
          (oauth_response && session_class.controller.session && session_class.controller.session[:oauth_request_class] == self.class.name)
        end
      end

    end
  end
end
