class Api::V1::UsersController < ApplicationController
  def friends
  	puts @user.username
  	@users = User.all.reject { |u| u.id == @user.id }
  	render json: @users.map { |u| u.json }
  end
end
