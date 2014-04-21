# encoding: utf-8
MongoMapper.connection = Mongo::Connection.new('101.226.163.149', 27017)  
MongoMapper.database = 'cs_comments_service_development' 
  
if defined?(PhusionPassenger)  
   PhusionPassenger.on_event(:starting_worker_process) do |forked|  
     MongoMapper.connection.connect if forked  
   end  
end 
