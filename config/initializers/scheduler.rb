# encoding: utf-8
require 'rufus/scheduler'

scheduler = Rufus::Scheduler.start_new
@logger ||= Logger.new("log/scheduler.log")

scheduler.every '15s' do
  @mappings = LabEquipmentMapping.where(:status=>0)
  @mappings.each do |mapping|
      sql = "CREATE TABLE #{mapping.table_name}_reading (id int(11) NOT NULL AUTO_INCREMENT, point_id varchar(10) NOT NULL, read_at varchar(14) NOT NULL,saved_at varchar(14),value decimal(10,2),source varchar(2), PRIMARY KEY (`id`))ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;"
      min_sql = "CREATE TABLE #{mapping.table_name}_minute (id int(11) NOT NULL AUTO_INCREMENT, point_id varchar(10) NOT NULL, minute varchar(12) NOT NULL,value decimal(10,2),source varchar(2), PRIMARY KEY (`id`))ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;"
      quarter_sql = "CREATE TABLE #{mapping.table_name}_quarter (id int(11) NOT NULL AUTO_INCREMENT, point_id varchar(10) NOT NULL, minute varchar(12) NOT NULL,value decimal(10,2),source varchar(2), PRIMARY KEY (`id`))ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;"
      hour_sql = "CREATE TABLE #{mapping.table_name}_hour (id int(11) NOT NULL AUTO_INCREMENT, point_id varchar(10) NOT NULL, hour varchar(10) NOT NULL,value decimal(10,2),source varchar(2), PRIMARY KEY (`id`))ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;"
      day_sql = "CREATE TABLE #{mapping.table_name}_day (id int(11) NOT NULL AUTO_INCREMENT, point_id varchar(10) NOT NULL, day varchar(8) NOT NULL,value decimal(10,2),source varchar(2), PRIMARY KEY (`id`))ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;"
      ActiveRecord::Base.connection.execute(sql)
      ActiveRecord::Base.connection.execute(min_sql)
      ActiveRecord::Base.connection.execute(quarter_sql)
      ActiveRecord::Base.connection.execute(hour_sql)
      ActiveRecord::Base.connection.execute(day_sql)
      mapping.status = 1
      mapping.save
  end
end
