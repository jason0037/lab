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

puts "Importing options"
Option.delete_all
ActiveRecord::Base.connection.execute("alter table options auto_increment=1")
Option.create([{id:'1', name: '电子书包',value:"1",index:"0",key:"eval_object_type"},
	{id:'2', name: '开放学习资源',value:"2",index:"2",key:"eval_object_type"},
	{id:'3', name: '新闻',value:"1",index:"0",key:"notice_type"},
	{id:'4', name: '公告',value:"2",index:"1",key:"notice_type"},
	{id:'5', name: '未发布',value:"0",index:"0",key:"notice_status"},
	{id:'6', name: '已发布',value:"1",index:"1",key:"notice_status"},
	{id:'7', name: '通识教育课',value:"1",index:"0",key:"course_type"},
	{id:'8', name: '学科基础课',value:"2",index:"1",key:"course_type"},
	{id:'9', name: '专业必修课',value:"3",index:"2",key:"course_type"},
	{id:'10', name: '专业选修课',value:"4",index:"3",key:"course_type"},
	{id:'11', name: '任意选修课',value:"5",index:"4",key:"course_type"},
	{id:'12', name: '实践教学课',value:"6",index:"5",key:"course_type"}])
puts "Importing lab_notices"
LabNotice.delete_all
ActiveRecord::Base.connection.execute("alter table lab_notices auto_increment=1")
LabNotice.create([{id:'1', title: '文章标题一',body:"<p>我的哈哈大富科技</p><p>的佛挡杀佛接口的书法家看电视f</p><p>的佛挡杀佛</p>",cat_id:"1",published_at:"2014-03-31 00:00:00",published:"1",notice_type:"1"},
	{id:'2', title: '文章标题2',body:"<p>我的哈哈大富科技</p><p>的佛挡杀佛接口的书法家看电视f</p><p>的佛挡杀佛</p>",cat_id:"1",published_at:"2014-03-31 00:00:00",published:"1",notice_type:"1"},
	{id:'3', title: '文章标题3',body:"<p>我的哈哈大富科技</p><p>的佛挡杀佛接口的书法家看电视f</p><p>的佛挡杀佛</p>",cat_id:"1",published_at:"2014-03-31 00:00:00",published:"1",notice_type:"1"},
	{id:'4', title: '文章标题4',body:"<p>我的哈哈大富科技</p><p>的佛挡杀佛接口的书法家看电视f</p><p>的佛挡杀佛</p>",cat_id:"1",published_at:"2014-03-31 00:00:00",published:"1",notice_type:"1"},
	{id:'5', title: '文章标题5',body:"<p>我的哈哈大富科技</p><p>的佛挡杀佛接口的书法家看电视f</p><p>的佛挡杀佛</p>",cat_id:"1",published_at:"2014-03-31 00:00:00",published:"1",notice_type:"1"},
	{id:'6', title: '文章标题6',body:"<p>我的哈哈大富科技</p><p>的佛挡杀佛接口的书法家看电视f</p><p>的佛挡杀佛</p>",cat_id:"1",published_at:"2014-03-31 00:00:00",published:"1",notice_type:"2"},
	{id:'7', title: '文章标题7',body:"<p>我的哈哈大富科技</p><p>的佛挡杀佛接口的书法家看电视f</p><p>的佛挡杀佛</p>",cat_id:"1",published_at:"2014-03-31 00:00:00",published:"1",notice_type:"2"},
	{id:'8', title: '文章标题8',body:"<p>我的哈哈大富科技</p><p>的佛挡杀佛接口的书法家看电视f</p><p>的佛挡杀佛</p>",cat_id:"1",published_at:"2014-03-31 00:00:00",published:"1",notice_type:"2"}])
puts "Importing lab_scenes"
LabScene.delete_all
ActiveRecord::Base.connection.execute("alter table lab_scenes auto_increment=1")
LabScene.create([{id:'1', name: '下雪天',limit:'10',desc:'下雪了小雪了'},
	{id:'2', name: '下雨天',limit:'10',desc:'下雨了小雪了'},
	{id:'3', name: '下葫芦天',limit:'10',desc:'下葫芦娃了小雪了'}])
puts "Importing lab_suppliers"
LabSupplier.delete_all
ActiveRecord::Base.connection.execute("alter table lab_suppliers auto_increment=1")
LabSupplier.create([{id:'1', name: '供应商1',tel:'1500004112',contacts:'超人',addr:"地球1号"},
	{id:'2', name: '供应商2',tel:'1500004112',contacts:'超人1',addr:"火星2号"},
	{id:'3', name: '供应商3',tel:'1500004112',contacts:'超人2',addr:"太阳3号"}])
puts "Importing projects"
LabEvalProject.delete_all
ActiveRecord::Base.connection.execute("alter table lab_eval_projects auto_increment=1")
LabEvalProject.create([{id:'1', name: '电子书包1',version:"1.0.0",categery_id:'1',course_type:'2',scene_id:'1',supplier_id:'1',status:'1'},
	{id:'2', name: '电子书包项目2',version:"1.0.5",categery_id:'1',course_type:'2',scene_id:'1',supplier_id:'1',status:'1'},
	{id:'3', name: '电子书包项目3',version:"1.0.6",categery_id:'1',course_type:'2',scene_id:'1',supplier_id:'1',status:'1'},
	{id:'4', name: '电子书包项目4',version:"1.0.7",categery_id:'1',course_type:'2',scene_id:'1',supplier_id:'1',status:'1'},
	{id:'5', name: '电子书包项目5',version:"1.0.8",categery_id:'1',course_type:'2',scene_id:'1',supplier_id:'1',status:'1'}])





