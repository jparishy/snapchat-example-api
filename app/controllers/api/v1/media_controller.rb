require 'securerandom'

class Api::V1::MediaController < ApplicationController
  def upload
    uploaded_image = params[:file].tempfile

    path = ""
    image_url = ""

    loop do
      suffix = SecureRandom.hex
      path = "/uploads/snap_#{suffix}.jpg"
      image_url = "#{request.base_url}#{path}"

      break if Snap.where(image_url: image_url).count == 0
    end

    full_path = "#{Rails.root}/public#{path}"
    FileUtils.move uploaded_image.path, full_path

    response = { image_url: image_url }
    render json: response
  end
end
