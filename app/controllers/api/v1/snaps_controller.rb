class Api::V1::SnapsController < ApplicationController

  def index
    @snaps = Snap.where(to_user_id: @user.id, unread: true)

    json = @snaps.map do |s|
      { id: s.id, image_url: s.image_url, from_user: s.from_user.json, unread: s.unread, created_at: s.created_at }
    end

    render json: json
  end

  def show
    @snap = Snap.find(params[:id])
    if !@snap
      return render status: 404
    end

    render json: @snap
  end

  def create
    to_user_ids = params[:to]

    if !to_user_ids.is_a?(Array) then
      to_user_ids = [to_user_ids]
    end

    all_ints = to_user_ids.reduce(true) { |sum, n| sum && n.is_a?(Integer) }

    if !all_ints then
      return render nothing: true, status: 400
    end

    to_users = []
    to_user_ids.each do |user_id|
      to_users << User.where(id: user_id).first
    end

    any_nil = to_users.reduce(false) { |sum, n| sum || (n == nil) }
    if any_nil then
      return render nothing: true, status: 400
    end

    @snaps = []

    image_url = "http://placekitten.com/1080/1920"

    to_users.each do |to_user|
      snap = Snap.create(from_user_id: @user.id, to_user_id: to_user.id)
      snap.unread = true
      snap.image_url = image_url
      snap.save

      @snaps << snap
    end

    render json: @snaps
  end

  def mark_as_read
    @snap = Snap.find(params[:id])
    if !@snap
      return render status: 404
    end

    @snap.unread = false
    @snap.image_url = nil
    @snap.save

    render json: @snap
  end
end