require 'securerandom'

BUCKET_NAME = "snapchat-api-photos"

class Api::V1::MediaController < ApplicationController
  def upload
    uploaded_image = params[:file].tempfile


    file_name = ""
    image_url = ""

    loop do
      suffix = SecureRandom.hex
      file_name = "snaps/snap_#{suffix}.jpg"
      image_url = "https://snapchat-api-photos.s3.amazonaws.com/#{file_name}"

      break if Snap.where(image_url: image_url).count == 0
    end

    begin
      s3 = Aws::S3::Resource.new(region:'us-east-1')
      bucket = s3.bucket(BUCKET_NAME)
      object = bucket.object(file_name)

      file_path = uploaded_image.path 
      object.upload_file(file_path)

      response = { image_url: object.public_url.to_s }
      render json: response
    rescue Exception => e
      render nothing: true, status: 500
    end
  end
end
