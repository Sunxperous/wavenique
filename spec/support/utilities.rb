def sign_in(user)
  controller.stub(:current_user) { user }
end
