class User < ApplicationRecord
  validates :login, presence: true
  validates :user_info, presence: true

  #Save user info in database
  def self.save_user(user)
    user_found = self.find_by login: user['login']
    if user_found == nil
      create_user(user)
    else
      update_user(user_found, user)
    end
  end

  #Create new record in table users
  def self.create_user(user)
    new_user = User.create(login: user['login'], user_info: user)
    if new_user.save
      puts "user #{user['login']} successfully saved to database"
    else
      raise "Unable to save user #{user['login']} due to error: #{user.save!}"
    end
  end

  #Update existing record in table users
  def self.update_user(user_found, user_info)
    user_found.user_info = user_info
    if user_found.save
      puts "user #{user_found.login} successfully updated in database"
    else
      raise "Unable to update user #{user_found.login} due to error: #{user_found.save!}"
    end
  end

end