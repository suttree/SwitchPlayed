# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  # Is the +current_user+ logged in
  def logged_in?
    ! current_user.nil?
  end
  
  # Returns true if the +current_user+ has bet on this +period+
  def bet_placed(period)
    if (current_user.current_bets.include? period)
      return 'selected'
    else
      return false
    end 
  end

  # Highlights a header link if the current page matches
  def hdr_class_if_current_page?(controller, action)
    return "class='nav_current'" if @controller.controller_name == controller and @controller.action_name == action
  end
  
  # Highlights a footer link if the current page matches
  def ftr_class_if_current_page?(controller, action)
    return "class='ftr_current'" if @controller.controller_name == controller and @controller.action_name == action
  end
  
  # Allows the rendering of default content in a view
  # From http://inventivelabs.com.au/weblog/post/providing-default-content-in-rails-layouts/
  def default_content_for(name, &block)
    name = name.kind_of?(Symbol) ? ":#{name}" : name
    out = eval("yield #{name}", block.binding)
    concat(out || capture(&block))
  end
end
