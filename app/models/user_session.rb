class UserSession < Authlogic::Session::Base
  def self.oauth_consumer
    OAuth::Consumer.new('GdD5vEz0en58Yu31mlfZjA', 'bH3VxO75lOmKtsH9YFBtWfsBnTwiRr3aArlTv0M41I',
    { :site => "http://twitter.com",
      :authorize_url => "http://twitter.com/oauth/authenticate" })
  end
end
