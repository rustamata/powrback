class ApplicationController < ActionController::Base
  before_action :authenticate, except: [:callback, :index, :show, :github]

  CLIENT_ID = ENV['GH_BASIC_CLIENT_ID']
  CLIENT_SECRET = ENV['GH_BASIC_SECRET_ID']
  APP_NAME = ENV['GH_BASIC_APP_NAME']

  use Rack::Session::Pool, :cookie_only => false

  protected def save_token_info_to_session(response)
    session[:access_token] = response['access_token']
    session[:scope] = response['scope']
  end

  protected def clean_token_info_inside_session
    session[:access_token] = nil
    session[:scope] = nil
  end

  protected def user_has_privilege?(privilege)
    scope = session[:scope]
    return scope.include? privilege
  end

  protected def get_session_token
    return session[:access_token]
  end

  protected def authenticated?
    session[:access_token]
  end

  private def authenticate
    if !authenticated?
      redirect_to "/login"
    end
  end
  
end