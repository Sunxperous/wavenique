class User < ActiveRecord::Base
  require_dependency 'user/google'
  include ::Google
  attr_accessible :name
  has_one :youtube,
    class_name: 'User::Google',
    foreign_key: 'user_id'
  before_save :create_remember_token

  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end
