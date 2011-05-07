class Time
  def to_google_s
    if Time.now.beginning_of_day <= self
      self.hour.to_s + ":" + self.min.to_s + " " + self.strftime('%p').downcase
    elsif Time.now.beginning_of_year <= self
      self.strftime('%b ') + self.day.to_s
    else
      self.month.to_s + '/' + self.day.to_s + '/' + self.strftime('%y')
    end
  end
end

Date::DATE_FORMATS[:date_short] = '%d/%m/%Y'
Date::DATE_FORMATS[:date_long] = '%e%S %B %Y'
Date::DATE_FORMATS[:weekday_month_ordinal] = lambda { |time| time.strftime("#{time.day.ordinalize} %B %Y") }
Time::DATE_FORMATS[:date_with_time] = '%d/%m/%Y, %H:%M'
Time::DATE_FORMATS[:time_without_date] = '%H:%M'
Time::DATE_FORMATS[:time_with_seconds] = '%H:%M:%S'
Time::DATE_FORMATS[:time_without_seconds] = '%H:%M'
