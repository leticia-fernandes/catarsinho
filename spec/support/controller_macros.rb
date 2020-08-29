module ControllerMacros
  def login_user(user=nil)
    @request.env["devise.mapping"] = Devise.mappings[:user]
    user_logged = user || FactoryBot.create(:user)
    sign_in user_logged
  end
end
