class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session

  before_action :validate_api_token
  skip_before_filter  :verify_authenticity_token

  private

  def validate_api_token
    token_str = request.headers["X-Api-Token"]
    api_token = ApiToken.where(value: token_str).first
    if !api_token then
      return head(401)
    end

    @user = api_token.user
    if !@user then
      return head(401)
    end
  end

end
