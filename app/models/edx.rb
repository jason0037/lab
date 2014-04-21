module Edx
	def self.database_config
		@edx ||= YAML.load_file(Rails.root.join("config","edx.yml"))[Rails.env]
	end
	
	class Base < ActiveRecord::Base
		self.abstract_class = true
		self.establish_connection(Edx.database_config)

		def self.accessible_all_columns
			self.column_names.each do |col|
          		attr_accessible col.to_sym
       		end
		end
	end
end