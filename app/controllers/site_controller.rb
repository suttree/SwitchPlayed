class SiteController < ApplicationController
  permit 'admin', :only => 'admin'

  def home
    render :layout => 'portfolium-homepage'
  end
  
  def about
  end
  
  def blog
  end
  
  def contact
  end
  
  def faq
  end

  def admin
  end
end
