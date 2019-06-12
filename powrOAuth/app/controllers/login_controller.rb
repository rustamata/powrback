class LoginController < ApplicationController

  def show #show login page
    #Do not show login form to authenticated users
    if authenticated?
      redirect_to pages_edit_path
    end
  end

  def oauth #go to GitHub for authorization
    redirect_to "https://github.com/login/oauth/authorize?state=#{get_guid}&scope=read:user,user:email,repo&client_id=#{get_client_id}"
  end

  def callback #receive callback from GitHub
    save_session_token(get_github_token(params[:code], params[:state]))
    save_user_to_db
    redirect_to pages_edit_path
  end

  def logout #logout from app
    destroy_session_token
    redirect_to login_path
  end


  private def get_github_token(access_code, auth_state) #get token from GitHub
    begin
      return HTTParty.post('https://github.com/login/oauth/access_token',
                           body: {client_id: get_client_id, client_secret: get_client_secret, code: access_code, state: auth_state},
                           headers: {Accept: "application/json"})
    rescue
      raise "Unable to get token from GitHub, #{$!}"
    end
  end

  private def get_github_user #get user info from GitHub
    begin
      return HTTParty.get('https://api.github.com/user',
                          headers: {"User-Agent": get_app_name, Authorization: "token #{get_session_token}", Accept: "application/json"})
    rescue
      raise "Unable to get user info from GitHub, #{$!}"
    end
  end

  private def save_user_to_db #save GitHub user info to our DB
    if user_has_privilege?('read:user')
      User.save_user(get_github_user)
    else
      raise "Insufficient privileges, can't save user to DB"
    end
  end

  private def get_session_token #get GitHub token from session
    session[:access_token]
  end

  private def save_session_token(response) #save GitHub token and scope to session
    session[:access_token] = response['access_token']
    session[:scope] = response['scope']
  end

  private def destroy_session_token #delete GitHub token and scope from session
    session.delete(:access_token)
    session.delete(:scope)
  end

  private def user_has_privilege?(privilege) #check if user has privilege (true/false)
    scope = session[:scope]
    scope.include? privilege
  end

  private def get_client_id #get application's client_id from environment variable
    ENV['GH_BASIC_CLIENT_ID']
  end

  private def get_client_secret #get application's client_secret from environment variable
    ENV['GH_BASIC_SECRET_ID']
  end

  private def get_app_name #get application's name from environment variable
    ENV['GH_BASIC_APP_NAME']
  end

  private def get_guid
    SecureRandom.uuid
  end

end