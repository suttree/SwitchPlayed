class Transaction < ActiveRecord::Base
  belongs_to :user
  belongs_to :game
  validates_presence_of :user_id, :amount, :status

  class << self
    def debit(user, amount, options = {})
      create_with(user, amount, 'debit', options)
    end

    def credit(user, amount, options = {})
      create_with(user, amount, 'credit', options)
    end

    protected
    def create_with(user, amount, status, options = {})
      create!(
        :user_id => user.id,
        :amount => amount,
        :status => status,
        :game_id => options[:game_id],
        :session_id => options[:session_id],
        :remote_ip => options[:remote_ip]
      )
    end
  end
end
