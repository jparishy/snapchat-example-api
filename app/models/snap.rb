class Snap < ActiveRecord::Base
	belongs_to :from_user, class_name: "User", dependent: :delete
	belongs_to :to_user, class_name: "User"

	def json
		{ id: self.id, image_url: self.image_url, to_user: self.to_user.json, from_user: self.from_user.json, unread: self.unread, created_at: self.created_at }
	end
end
