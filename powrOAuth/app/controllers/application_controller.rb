class ApplicationController < ActionController::Base
  before_action :authenticate, except: [:callback, :index, :show]

  CLIENT_ID = ENV['GH_BASIC_CLIENT_ID']
  CLIENT_SECRET = ENV['GH_BASIC_SECRET_ID']
  APP_NAME = "powerfulOAuth"

  use Rack::Session::Pool, :cookie_only => false

  def callback
    save_token_and_scope_to_session(get_github_token_and_scope(params[:code]))
    save_user_info_to_db
    if authenticated?
      redirect_to "/pages/edit"
    else
      redirect_to "login/show"
    end
  end

  protected def authenticated?
    session[:access_token]
  end

  private def authenticate
    #@state = SecureRandom.uuid #!Передать state для защиты
    if !authenticated?
      redirect_to "login/show"
    end
  end

  private def save_token_and_scope_to_session(response)
    session[:access_token] = response['access_token']
    session[:scope] = response['scope']
  end

  private def get_github_token_and_scope(access_code)
    return HTTParty.post('https://github.com/login/oauth/access_token',
                         body: {client_id: CLIENT_ID, client_secret: CLIENT_SECRET, code: access_code},
                         headers: {Accept: "application/json"})
  end

  private def get_github_user_info
    return HTTParty.get('https://api.github.com/user',
                        headers: {"User-Agent": "powerfulOAuth", Authorization: "token #{session[:access_token]}", Accept: "application/json"})
  end

  private def save_user_info_to_db
    if user_has_privilege('read:user')
      User.save_user(get_github_user_info)
    else
      raise "Insufficient privileges, can't save user to DB"
    end
  end

  protected def user_has_privilege(privilege)
    scope = session[:scope]
    return scope.include? privilege
  end

end