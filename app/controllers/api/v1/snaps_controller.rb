class Api::V1::SnapsController < ApplicationController

  def index
    to_snaps = Snap.where(to_user_id: @user.id)
    from_snaps = Snap.where(from_user_id: @user.id)

    @snaps = []
    @snaps.concat to_snaps
    @snaps.concat from_snaps

    @snaps = @snaps.sort_by &:created_at

    json = @snaps.map do |s|
      s.json
    end

    render json: json
  end

  def show
    @snap = Snap.where(id: params[:id]).first
    if !@snap
      return render nothing: true, status: 404
    end

    if @snap.to_user_id != @user.id then
      return render nothing: true, status: 401
    end

    render json: @snap.json
  end

  def create
    to_user_ids = params[:to]
    image_url = params[:image_url]

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

    if image_url == nil || image_url.length == 0 then
      return render nothing: true, status: 400
    end

    @snaps = []

    to_users.each do |to_user|
      snap = Snap.create(from_user_id: @user.id, to_user_id: to_user.id)
      snap.unread = true
      snap.image_url = image_url
      snap.save

      @snaps << snap
    end

    render json: @snaps.map { |s| s.json }
  end

  def mark_as_read
    @snap = Snap.where(id: params[:id]).first
    if !@snap
      return render nothing: true, status: 404
    end

    if @snap.to_user_id != @user.id then
      return render nothing: true, status: 401
    end

    @snap.unread = false
    @snap.image_url = nil
    @snap.save

    render json: @snap.json
  end
end