require 'securerandom'

class Api::V1::UsersController < ApplicationController
  
  skip_before_filter :validate_api_token, only: :authenticate

  def friends
    @users = User.all.reject { |u| u.id == @user.id }
    render json: @users.map { |u| u.json }
  end

  def authenticate
    username = params[:username]
    password = params[:password]

    if !username || username.length == 0 then
      return render nothing: true, status: 400
    end

    if !password || password.length == 0 then
      return render nothing: true, status: 400
    end

    @user = User.where(username: username).first
    if !@user then
      return render nothing: true, status: 401
    end

    if !@user.authenticate(password) then
      return render nothing: true, status: 401
    end

    api_token_value = ""

    loop do
      api_token_value = SecureRandom.hex
      break if ApiToken.where(value: api_token_value).count == 0
    end

    ApiToken.where(user: @user).each do |token|
      token.delete
    end

    api_token = ApiToken.create(user: @user, value: api_token_value)

    json = {
      user: @user.json,
      api_token: api_token.value
    }

    render json: json
  end
end
