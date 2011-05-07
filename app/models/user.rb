class User < ActiveRecord::Base
  acts_as_authentic
  
  # Authorization plugin
  acts_as_authorized_user
  acts_as_authorizable

  has_many :bets

  #attr_accessible blah...
    
  def name
    (self.twitter_name? ? self.twitter_name : self.facebook_name)
  end

  def admin?
    self.has_role? 'admin'
  end

  # Move this to a Payment module
  # Credits the +User+ with +amount+ and returns the updated balance
  # +options+ can optionally include game_id, remote_ip and session_id
  # - needs locking
  def credit(amount, options = {})
    transaction do
      begin
        Transaction.credit(self, amount, options)
        self.balance += amount
      rescue ActiveRecord::StatementInvalid
        self.balance -= amount
      end
    end
    self.save!
    self.balance
  end
  
  # Debits +amount+ from the the +User+ and returns the updated balance
  # +options+ can optionally include game_id, remote_ip and session_id
  # - needs locking
  def debit(amount, options = {})
    transaction do
      begin
        Transaction.debit(self, amount, options)
        self.balance -= amount
      rescue ActiveRecord::StatementInvalid
        self.balance += amount
      end
    end
    self.save!
    self.balance
  end

  # Debits the user for access to the chatroom
  # +options+ can optionally include game_id, remote_ip and session_id
  def charge_for_chatroom_access(options = {})
    self.debit(Settings.chatroom_access_cost, options)
  end

  # Move this to a Betting module
  # - needs locking
  def can_afford_to_bet?(amount)
    (self.balance >= amount)
  end

  # Checks to see a +user+ has more than £1 to play with
  def has_enough_money_to_play?
    (self.balance >= 1)
  end

  # Returns an array of all bets this user has made on an in-progress game
  def current_bets
    if Game.in_progress?
      self.bets.find_all_by_game_id(Game.in_progress.id).collect{ |b| b.period }
    else
      []
    end
  end
  
  # Formatted version of +balance+
  include ActionView::Helpers::NumberHelper
  def current_balance
    number_to_currency(balance, :unit => '&pound;')
  end
  
  # Move this to a twitter module
  def twitter_connect
    access_token = OAuth::AccessToken.new(UserSession.oauth_consumer, self.oauth_token, self.oauth_secret)
    user_info = JSON.parse(access_token.get("https://twitter.com/account/verify_credentials.json").body)
    self.twitter_name = user_info['name']
    self.twitter_screen_name = user_info['screen_name']
    self.login = 'twitter_' + user_info['screen_name']
    self.password = "5uttr33_#{self.login}"
    self.signup_source = 'twitter'
    self.save
  end
  
  def twitter_user?
    @signup_source ||= (signup_source == 'twitter')
  end
  
  # Store this in the db on sign-in/sign-up?
  def twitter_profile_image
    @profile_image ||= begin
      require 'open-uri'
      require 'json'
      buffer = open("http://twitter.com/users/show/#{self.twitter_screen_name}.json").read
      result = JSON.parse(buffer)
      result['profile_image_url']
    end
  end

  
  # Move this to a facebook module
  def before_connect(facebook_session)
    self.login = 'facebook_' + facebook_session.user.name
    self.facebook_name = facebook_session.user.name
    self.password = "5uttr33_#{self.login}"
    self.signup_source = 'facebook'
  end
  
  def facebook_user?
    (signup_source == 'facebook')
  end
end
