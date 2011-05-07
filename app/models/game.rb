class Game < ActiveRecord::Base
  named_scope :current, lambda{{:conditions => ['start_time <= ? AND end_time >= ?', Time.now, Time.now], :order => 'start_time DESC', :limit => 1}}
  named_scope :upcoming, lambda{{:conditions => ['start_time >= ?', Time.now], :limit => 1}}

  before_validation_on_create :generate_unique_pip
  validates_presence_of :pip, :home_team, :away_team, :start_time, :end_time

  has_one :score
  has_many :bets

  def current_score
    if self.score.nil?
      '0 - 0'
    else
      "#{score.home_team} - #{score.away_team}"
    end
  end

  # Stealing the idea of 'pip's from the BBC, where they were
  # used as "programme information pages". Here, we'd like a
  # random string to identify each game, rather than using the
  # autoincremented id
  def generate_unique_pip(size = 5)
    self.pip = generate_pip(size)
    unless (Game.find_by_pip(self.pip))
      self.pip = generate_pip(size)
    end
    self.pip
  end

  def generate_pip(size)
    chars = ('a'..'z').to_a + ('0'..'9').to_a
    s = ''
    1.upto(size) { |i| s << chars[rand(chars.size-1)] }
    s
  end

  class << self

    # Is a game happening?
    def in_progress?
      Game.current.any?
    end

    # The currently playing game
    def in_progress
      Game.current.first
    end

    # Details of the next game - home team vs away team
    def upcoming_details
      game = Game.upcoming
      if game.any?
        "#{game.first.home_team.titleize} vs. #{game.first.away_team.titleize}"
      else
        'Check back later for details of our next game'
      end
    end

    def upcoming_date
      game = Game.upcoming
      game.empty? ? '' : game.first.start_time.to_date.to_s(:weekday_month_ordinal)
    end
  end
end
