class Bet < ActiveRecord::Base
  belongs_to :game
  belongs_to :user
  before_validation_on_create :check_user_balance
  validates_presence_of :user_id, :game_id, :amount, :period, :remote_ip

  private
  def check_user_balance
    if (self.user.can_afford_to_bet? self.amount)
      return true
    else
      errors.add("Insufficient funds", "for this bet")
      return false
    end
  end

  # Custom validations to make sure our inputs are
  # within anticpated boundaries
  def validate
    validate_amount
    validate_game
    validate_period
  end

  def validate_amount
    if (self.amount > 0 && self.amount <= 10.00)
      return true
    else
      errors.add("Amount bet", "is invalid")
      return false
    end
  end

  def validate_game
    if (Game.in_progress.id == self.game_id)
      return true
    else
      errors.add("Associated game", "is invalid")
      return false
    end
  end

  def validate_period
    periods = Settings.first_half_periods + Settings.second_half_periods
    if (periods.include? self.period)
      return true
    else
      errors.add("Chosen period", "is invalid")
      return false
    end
  end
end
