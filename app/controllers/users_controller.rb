class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update]
  permit 'admin', :only => :index
  
  def index
    @users = User.all
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    @user.save do |result|
      if result
        # Connect twitter/facebook details
        session[:oauth_request_class] = nil # stop authlogic_oauth from registering with twitter a 2nd time
        @user.twitter_connect
        flash[:notice] = "Account registered!"
      else
        if @user.oauth_token.nil?
          flash[:notice] = "There was an error, we are investigating"
          redirect_to root_url && return
        else
          @user = User.find_by_oauth_token(@user.oauth_token)
          unless @user.nil?
            UserSession.create(@user)
            flash[:notice] = "Welcome back!"
          end
        end
      end
      redirect_to root_url
    end
  end
    
  def show
    @user = @current_user
  end
 
  def edit
    @user = @current_user
  end
  
  def update
    @user = @current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to account_url
    else
      render :action => :edit
    end
  end
end
