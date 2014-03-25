# encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts "Importing lab_users"
LabUser.delete_all
ActiveRecord::Base.connection.execute("alter table lab_users auto_increment=1")
LabUser.create([{name: 'apply',mobile: '15888801441',email: 'jason.chen@iotps.com',account: 'apply@iotps.com',password: 'e10adc3949ba59abbe56e057f20f883e',role_id: '1',status:'1'},
	{name: 'user',mobile: '15888801441',email: 'jason.chen@iotps.com',account: 'teacher@iotps.com',password: 'e10adc3949ba59abbe56e057f20f883e',role_id: '2',status:'1'},
	{name: 'course_admin',mobile: '15888801441',email: 'jason.chen@iotps.com',account: 'course_admin@iotps.com',password: 'e10adc3949ba59abbe56e057f20f883e',role_id: '3',status:'1'},
	{name: 'lab_admin',mobile: '15888801441',email: 'jason.chen@iotps.com',account: 'lab_admin@iotps.com',password: 'e10adc3949ba59abbe56e057f20f883e',role_id: '4',status:'1'},
	{name: 'student',mobile: '15888801441',email: 'jason.chen@iotps.com',account: 'student@iotps.com',password: 'e10adc3949ba59abbe56e057f20f883e',role_id: '5',status:'1'},
	{name: 'system',mobile: '15888801441',email: 'jason.chen@iotps.com',account: 'system@iotps.com',password: 'e10adc3949ba59abbe56e057f20f883e',role_id: '6',status:'1'}])
puts "Importing lab_roles"
LabRole.delete_all
ActiveRecord::Base.connection.execute("alter table lab_roles auto_increment=1")
LabRole.create([{id:'1', name: '评测申请人',path:"apply_manage_lab_users_path"},
	{id:'2',name: '教师',path:"teacher_manage_lab_users_path"},
	{id:'3',name: '课程管理员',path:"admin_manage_lab_users_path"},
	{id:'4',name: '实验室管理员',path:"lab_manage_lab_users_path"},
	{id:'5',name: '学生',path:"student_manage_lab_users_path"},
	{id:'6',name: '系统管理员',path:"system_manage_lab_users_path"}])



