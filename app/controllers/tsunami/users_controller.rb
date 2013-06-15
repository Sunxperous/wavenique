class Tsunami::UsersController < TsunamiController
  def index
    @users = User.all
  end
end
