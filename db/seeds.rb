# encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
puts "Importing lab_teach_designs"
LabTeachDesign.delete_all
ActiveRecord::Base.connection.execute("alter table lab_teach_designs auto_increment=1")
LabTeachDesign.create([{id: '1', title: '课程设计1',author_id: '2',course_type: '2',file: 'abcdefg.ppt',status: '0',brief: '课程设计1课程设计1'},
                       {id: '2', title: '课程设计2',author_id: '2',course_type: '3',file: 'hijklmn.doc',status: '1',brief: '课程设计2课程设计2'}
                      ])

puts "Importing lab_teach_resources"
LabTeachResource.delete_all
ActiveRecord::Base.connection.execute("alter table lab_teach_resources auto_increment=1")
LabTeachResource.create([{id:'1', title: '课件资源1',author_id:'2',course_type:'2',file:'abcdefg.ppt',status:'0',brief:'课件资源1课件资源1'},
                       {id:'2', title: '课件资源2',author_id:'2',course_type:'3',file:'hijklmn.doc',status:'1',brief:'课件资源2课件资源2'}
                      ])

puts "Importing lab_mobile_courses"
LabMobileCourse.delete_all
ActiveRecord::Base.connection.execute("alter table lab_mobile_courses auto_increment=1")
LabMobileCourse.create([{id:'1', title: '移动课程1',author_id:'2',course_type:'2',file:'abcdefg.ppt',status:'0',brief:'移动课程1移动课程1'},
                       {id:'2', title: '移动课程2',author_id:'2',course_type:'3',file:'hijklmn.doc',status:'1',brief:'移动课程2移动课程2'}
                      ])

puts "Importing lab_users"
LabUser.delete_all
ActiveRecord::Base.connection.execute("alter table lab_users auto_increment=1")
LabUser.create([{name: 'apply',mobile: '15888801441',email: 'jason.chen@iotps.com',account: 'apply@iotps.com',password: 'e10adc3949ba59abbe56e057f20f883e',role_id: '1',status:'1'},
	{name: 'teacher',mobile: '15888801441',email: 'jason.chen@iotps.com',account: 'teacher@iotps.com',password: 'e10adc3949ba59abbe56e057f20f883e',role_id: '2',status:'1'},
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
	{id:'12', name: '实践教学课',value:"6",index:"5",key:"course_type"},
  {id:'13', name: '草稿',value:"0",index:"1",key:"eval_status"},
  {id:'14', name: '审批中',value:"1",index:"2",key:"eval_status"},
  {id:'15', name: '审批通过',value:"2",index:"3",key:"eval_status"},
  {id:'16', name: '审批拒绝',value:"-1",index:"4",key:"eval_status"},
  {id:'17', name: '评测结束',value:"10",index:"5",key:"eval_status"},
  {id:'18', name: '课程信息',value:"3",index:"2",key:"notice_type"},
  {id:'19', name: '评测信息',value:"4",index:"3",key:"notice_type"},
  {id:'20',name:'实验室学习脑波评测',value:"1",index:"1",key:"eval_means"},
  {id:'21',name:'实验室学习行为体态评测',value:"2",index:"2",key:"eval_means"},
  {id:'22',name:'实验室学习终端采集数据评测',value:"3",index:"3",key:"eval_means"},
  {id:'23',name:'实验室学习网络采集数据评测',value:"4",index:"4",key:"eval_means"},
  {id:'24',name:'实验室学习能耗采集数据评测',value:"5",index:"5",key:"eval_means"},
  {id:'25',name:'实验室学习硬件兼容性评测',value:"6",index:"6",key:"eval_means"},
  {id:'26',name:'人工问卷评测',value:"7",index:"7",key:"eval_means"},
  {id:'27',name:'线上行为采集数据评测',value:"8",index:"8",key:"eval_means"},
  {id:'28',name:'UX Office可用性评测',value:"9",index:"9",key:"eval_means"},
  {id:'29',name:'眼动仪数据评测',value:"10",index:"10",key:"eval_means"},
  {id:'30',name:'可穿戴设备数据评测',value:"11",index:"11",key:"eval_means"}
  ])

puts "Importing lab_notices"
LabNotice.delete_all
ActiveRecord::Base.connection.execute("alter table lab_notices auto_increment=1")
LabNotice.create([{id:'1', title: '文章标题一',body:"<p>我的哈哈大富科技</p><p>的佛挡杀佛接口的书法家看电视f</p><p>的佛挡杀佛</p>",cat_id:"1",published_at:"2014-03-31 00:00:00",published:"1",notice_type:"1"},
	{id:'2', title: '文章标题2',body:"<p>我的哈哈大富科技</p><p>的佛挡杀佛接口的书法家看电视f</p><p>的佛挡杀佛</p>",cat_id:"1",published_at:"2014-03-31 00:00:00",published:"1",notice_type:"1"},
	{id:'3', title: '文章标题3',body:"<p>我的哈哈大富科技</p><p>的佛挡杀佛接口的书法家看电视f</p><p>的佛挡杀佛</p>",cat_id:"1",published_at:"2014-03-31 00:00:00",published:"1",notice_type:"1"},
	{id:'4', title: '文章标题4',body:"<p>我的哈哈大富科技</p><p>的佛挡杀佛接口的书法家看电视f</p><p>的佛挡杀佛</p>",cat_id:"1",published_at:"2014-03-31 00:00:00",published:"1",notice_type:"2"},
	{id:'5', title: '文章标题5',body:"<p>我的哈哈大富科技</p><p>的佛挡杀佛接口的书法家看电视f</p><p>的佛挡杀佛</p>",cat_id:"1",published_at:"2014-03-31 00:00:00",published:"1",notice_type:"2"},
	{id:'6', title: '文章标题6',body:"<p>我的哈哈大富科技</p><p>的佛挡杀佛接口的书法家看电视f</p><p>的佛挡杀佛</p>",cat_id:"1",published_at:"2014-03-31 00:00:00",published:"1",notice_type:"3"},
	{id:'7', title: '文章标题7',body:"<p>我的哈哈大富科技</p><p>的佛挡杀佛接口的书法家看电视f</p><p>的佛挡杀佛</p>",cat_id:"1",published_at:"2014-03-31 00:00:00",published:"1",notice_type:"3"},
  {id:'8', title: '文章标题8',body:"<p>我的哈哈大富科技</p><p>的佛挡杀佛接口的书法家看电视f</p><p>的佛挡杀佛</p>",cat_id:"1",published_at:"2014-03-31 00:00:00",published:"1",notice_type:"4"},
	{id:'9', title: '文章标题8',body:"<p>我的哈哈大富科技</p><p>的佛挡杀佛接口的书法家看电视f</p><p>的佛挡杀佛</p>",cat_id:"1",published_at:"2014-03-31 00:00:00",published:"1",notice_type:"4"}])
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
puts "Importing lab_eval_projects"
LabEvalProject.delete_all
ActiveRecord::Base.connection.execute("alter table lab_eval_projects auto_increment=1")
LabEvalProject.create([{id:'1', name: '电子书包1',version:"1.0.0",category_id:'1',course_type:'2',scene_id:'1',supplier_id:'1',status:'0',applicant_id:'1'},
	{id:'2', name: '电子书包项目2',version:"1.0.5",category_id:'1',course_type:'2',scene_id:'3',supplier_id:'1',status:'1',applicant_id:'1'},
	{id:'3', name: '电子书包项目3',version:"1.0.6",category_id:'1',course_type:'2',scene_id:'2',supplier_id:'3',status:'2',applicant_id:'1'},
  {id:'4', name: '开放学习资源1',version:"1.0.7",category_id:'2',course_type:'3',scene_id:'1',supplier_id:'2',status:'10',applicant_id:'2'},
  {id:'5', name: '电子书包项目3',version:"1.0.6",category_id:'1',course_type:'2',scene_id:'2',supplier_id:'1',status:'10',applicant_id:'1'},
  {id:'6', name: '开放学习资源1',version:"1.0.7",category_id:'2',course_type:'3',scene_id:'1',supplier_id:'1',status:'0',applicant_id:'2'},
	{id:'7', name: '开放学习资源2',version:"1.0.8",category_id:'2',course_type:'4',scene_id:'2',supplier_id:'1',status:'1',applicant_id:'2'}])




