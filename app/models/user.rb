class User < ActiveRecord::Base
	has_many :snaps, foreign_key: "from_user_id", class_name: "Snap"
	has_many :api_tokens

	def json
		{ id: id, username: username}
	end
end
