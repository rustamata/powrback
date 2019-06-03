class LoginController < ApplicationController
  def show
    #Show login form to unauthorized users only
    if authenticated?
      redirect_to "/pages/edit"
    end
  end

  def gohub
    redirect_to "https://github.com/login/oauth/authorize?scope=read:user,user:email,repo&client_id=#{ENV['GH_BASIC_CLIENT_ID']}"
  end

end