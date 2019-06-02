class User < ApplicationRecord
  validates :login, presence: true, uniqueness: true  #!добавить индекс по логину для быстрого поиска
  validates :user_info, presence: true
end