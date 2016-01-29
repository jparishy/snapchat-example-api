class User < ActiveRecord::Base
	has_secure_password
	
	has_many :snaps, foreign_key: "from_user_id", class_name: "Snap"
	has_many :api_tokens
	has_many :push_notification_tokens

	def json
		{ id: id, username: username}
	end
end
