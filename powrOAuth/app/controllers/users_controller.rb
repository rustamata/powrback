class UsersController < ApplicationController
  CLIENT_ID = ENV['GH_BASIC_CLIENT_ID']
  CLIENT_SECRET = ENV['GH_BASIC_SECRET_ID']
  APP_NAME = "powerfulOAuth"

  def authorize
    #@state = SecureRandom.uuid #!Передать state для защиты
    redirect_to "https://github.com/login/oauth/authorize?scope=read:user,user:email&client_id=#{ENV['GH_BASIC_CLIENT_ID']}"
  end

  def callback
    response = HTTParty.post('https://github.com/login/oauth/access_token',
                             body: {client_id: CLIENT_ID, client_secret: CLIENT_SECRET, code: params[:code]},
                             headers: {Accept: "application/json"})
    @access_token = response['access_token']
    @scope = response['scope']

    if @scope.include? 'read:user'
      response = HTTParty.get('https://api.github.com/user',
                              headers: {"User-Agent": "powerfulOAuth", Authorization: "token #{@access_token}", Accept: "application/json"})
      save_user(response)
    else
      puts "insufficient privileges"
    end
  end

  #Save user info in database
  private def save_user(user)
    user_found = User.find_by login: user['login']
    if user_found == nil
      create_user(user)
    else
      update_user(user_found, user)
    end
  end

  #Create new record in table users
  private def create_user(user)
    new_user = User.create(login: user['login'], user_info: user)
    if new_user.save
      puts "user #{user['login']} successfully saved to database"
    else
      raise "Unable to save user #{user['login']} due to error: #{user.save!}"
    end
  end

  #Update existing record in table users
  private def update_user(user_found, user_info)
    user_found.user_info = user_info
    if user_found.save
      puts "user #{user_found.login} successfully updated in database"
    else
      raise "Unable to update user #{user_found.login} due to error: #{user_found.save!}"
    end
  end

end