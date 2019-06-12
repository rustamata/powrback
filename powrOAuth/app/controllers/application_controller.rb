class ApplicationController < ActionController::Base
  before_action :authenticate, except: [:callback, :show, :oauth]

  use Rack::Session::Pool, :cookie_only => false

  private def authenticated?
    session[:access_token]
  end

  private def authenticate
    if !authenticated?
      redirect_to login_path
    end
  end

end