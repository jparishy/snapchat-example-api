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

  def add_push_notification_token
    token = params[:token]
    if token == nil then
      return render nothing: true, status: 400
    end

    value = token[:value]
    if value == nil || value.length == 0 then
      return render nothing: true, status: 400
    end

    existing_tokens = PushNotificationToken.where(user_id: @user.id, value: value)
    if existing_tokens.count != 0 then
      existing_value = existing_tokens.first.value
      json = { token: { value: existing_value } }
      return render json: json
    end

    new_token = PushNotificationToken.create(user_id: @user.id, value: value)
    new_token.save

    json = { token: { value: value } }
    render json: json
  end
end
