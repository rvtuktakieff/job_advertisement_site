module Authentication
  include ActionController::HttpAuthentication::Token

  def authenticate_user
    # Authorization: Bearer <token>
    token, _options = token_and_options(request)
    @user = User.find_by(id: token)
  end

  def current_user
    @user
  end
end
