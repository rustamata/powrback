class LoginController < ApplicationController

  def show
    #Show login form to unauthorized users only
    if authenticated?
      redirect_to "/pages/edit"
    end
  end

  def github
    redirect_to "https://github.com/login/oauth/authorize?state=#{SecureRandom.uuid}&scope=read:user,user:email,repo&client_id=#{ENV['GH_BASIC_CLIENT_ID']}"
  end

  def callback
    save_token_info_to_session(get_github_token_info(params[:code], params[:state]))
    save_user_info_to_db
    if authenticated?
      redirect_to "/pages/edit"
    else
      redirect_to "/login"
    end
  end

  def logout
    clean_token_info_inside_session
    redirect_to "/login"
  end

  private def get_github_token_info(access_code, auth_state)
    begin
      return HTTParty.post('https://github.com/login/oauth/access_token',
                           body: {client_id: CLIENT_ID, client_secret: CLIENT_SECRET, code: access_code, state: auth_state},
                           headers: {Accept: "application/json"})
    rescue
      raise "Unable to get token from GitHub, #{$!}"
    end
  end


  private def get_github_user_info
    begin
      return HTTParty.get('https://api.github.com/user',
                          headers: {"User-Agent": "powerfulOAuth", Authorization: "token #{get_session_token}", Accept: "application/json"})
    rescue
      raise "Unable to get user info from GitHub, #{$!}"
    end
  end

  private def save_user_info_to_db
    if user_has_privilege?('read:user')
      User.save_user(get_github_user_info)
    else
      raise "Insufficient privileges, can't save user to DB"
    end
  end

end