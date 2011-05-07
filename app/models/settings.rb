class Settings < Settingslogic
  source "#{Rails.root}/config/settings/application.yml"
  namespace Rails.env
end
