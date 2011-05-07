class FundsController < ApplicationController
  def index
  end
  
  def create
    flash[:notice] = "Account funded successfully, thank you!"
    case params[:fund_amount]
      when "5.00"
        current_user.credit(5.00, request.remote_ip)
      when "10.00"
        current_user.credit(10.00, request.remote_ip)
      when "25.00"
        current_user.credit(25.00, request.remote_ip)
      else
        flash[:notice] = "There was an error, please try again"
    end
    redirect_to '/funds'
  end
end
