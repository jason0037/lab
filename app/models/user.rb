# encoding: utf-8
class User
	include MongoMapper::Document

	key :username, String
	key :default_sort_key, String
	key :notification_ids, Array
	key :external_id, String
	key :email, String
end
