# encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

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
  {id:'20',name:'实验室学习脑波评测',value:"mind_wave",index:"1",key:"eval_means"},
  {id:'21',name:'实验室学习行为体态评测',value:"behaviour",index:"2",key:"eval_means"},
  {id:'22',name:'实验室学习终端采集数据评测',value:"terminal",index:"3",key:"eval_means"},
  {id:'23',name:'实验室学习网络采集数据评测',value:"network",index:"4",key:"eval_means"},
  {id:'24',name:'实验室学习能耗采集数据评测',value:"energy_consumption",index:"5",key:"eval_means"},
  {id:'25',name:'实验室学习硬件兼容性评测',value:"hardware_compatible",index:"6",key:"eval_means"},
  {id:'26',name:'人工问卷评测',value:"questionnaire",index:"7",key:"eval_means"},
  {id:'27',name:'线上行为采集数据评测',value:"online_behaviour",index:"8",key:"eval_means"},
  {id:'28',name:'UX Office可用性评测',value:"ux_office",index:"9",key:"eval_means"},
  {id:'29',name:'眼动仪数据评测',value:"eye_traking",index:"10",key:"eval_means"},
  {id:'30',name:'可穿戴设备数据评测',value:"wearable_equipment",index:"11",key:"eval_means"},
  {id:'31',name:'界面设计',value:"1",index:"1",key:"question_category",
   desc:"此部分用于考查课程或系统的界面一致性。即在学习者专注于课程学习的状态下是否有一些元素会分散学习者的注意力。"},
  {id:'32',name:'学习导航',value:"2",index:"2",key:"question_category",
   desc:"此部分用于考查课程或系统中是否有清晰的导航元素呈现给学习者，使他们能够快捷便利地找到要学习的内容。"},
  {id:'33',name:'媒体表现',value:"3",index:"3",key:"question_category",
   desc:"此部分用于考查课程或系统中的图表和媒体元素是否有用和是否好用。"},
  {id:'34',name:'交流沟通',value:"4",index:"4",key:"question_category",
   desc:"此部分用于考查课程或系统中是否有必要的交流沟通元素，以及交流沟通是否顺畅。"},
  {id:'35',name:'学习支持',value:"5",index:"5",key:"question_category",
   desc:"此部分用于考查课程或者系统中是否有必要的学习支持元素，以及学习支持是否到位。"},
  {id:'36',name:'内容要求',value:"6",index:"6",key:"question_category",
   desc:"此部分用于考查课程或系统中内容信息是否可以接受。"},
  {id:'37',name:'技术要求',value:"7",index:"7",key:"question_category",
   desc:"此部分用于考查前述问题中没有涉及的方面。"}
  ])

puts "Importign lab_questions"
LabQuestion.delete_all
ActiveRecord::Base.connection.execute("alter table lab_questions auto_increment=1")
LabQuestion.create([{id:'1',question_category:'1',desc:"页面功能区块划分（页面布局）是否合理？",version:'可用性评价规范1.0'},
    {id:'2',question_category:'1',desc:"各界面中元素的呈现方位是否一致？",version:'可用性评价规范1.0'},
    {id:'3',question_category:'1',desc:"各界面中元素的呈现形式是否一致?",version:'可用性评价规范1.0'},
    {id:'4',question_category:'1',desc:"各界面的颜色搭配是否协调一致？",version:'可用性评价规范1.0'},
    {id:'5',question_category:'1',desc:"各界面使用的颜色数是否会控制在5种以内？",version:'可用性评价规范1.0'},
    {id:'6',question_category:'1',desc:"各页面具有同样功能的文本是否同样大小？",version:'可用性评价规范1.0'},
    {id:'7',question_category:'1',desc:"各页面具有同样功能的文本是否同样类型？",version:'可用性评价规范1.0'},
    {id:'8',question_category:'1',desc:"各页面字体大小是否适合学习者学习？",version:'可用性评价规范1.0'},
    {id:'9',question_category:'1',desc:"各页面字体的类型是否易于辨认？",version:'可用性评价规范1.0'},
    {id:'10',question_category:'1',desc:"文本的行间距和字间距是否合理？",version:'可用性评价规范1.0'},
    {id:'11',question_category:'2',desc:"是否有一个易于理解和可达的课程主页或课程导航图？",version:'可用性评价规范1.0'},
    {id:'12',question_category:'2',desc:"是否在课程任何页面的任何位置都可以点击到课程主页或课程导航图？",version:'可用性评价规范1.0'},
    {id:'13',question_category:'2',desc:"是否学习者能够快速自由地到达课程的任何位置（三次点击以内是理想的）？",version:'可用性评价规范1.0'},
    {id:'14',question_category:'2',desc:"是否有链接与程序响应错误？",version:'可用性评价规范1.0'},
    {id:'15',question_category:'2',desc:"是否每一个有导航功能的词汇都不会发生歧义？",version:'可用性评价规范1.0'},
    {id:'16',question_category:'2',desc:"是否在课程任何页面下能清楚显示学习者当前位置?",version:'可用性评价规范1.0'},
    {id:'17',question_category:'2',desc:"链接导航区位置是否固定？",version:'可用性评价规范1.0'},
    {id:'18',question_category:'2',desc:"是否每页面都有意义鲜明的主题？",version:'可用性评价规范1.0'},
    {id:'19',question_category:'2',desc:"是否在每个页面上都有方便进入前后页的链接？",version:'可用性评价规范1.0'},
    {id:'20',question_category:'2',desc:"是否能方便地返回？",version:'可用性评价规范1.0'},
    {id:'21',question_category:'2',desc:"是否清晰地标识退出？",version:'可用性评价规范1.0'},
    {id:'22',question_category:'2',desc:"是否有容易导致退出课程或者系统的按钮？",version:'可用性评价规范1.0'},
    {id:'23',question_category:'2',desc:"是否有清晰地提示使课程或者系统的使用者了解他当前关注的文件其总量有多少？",version:'可用性评价规范1.0'},
    {id:'24',question_category:'3',desc:"是否所有图像都与课程有关？",version:'可用性评价规范1.0'},
    {id:'25',question_category:'3',desc:"是否所有图表都清楚易见、比例协调、无变形且大小合适？",version:'可用性评价规范1.0'},
    {id:'26',question_category:'3',desc:"声音是否自然流畅、清楚且无噪音？",version:'可用性评价规范1.0'},
    {id:'27',question_category:'3',desc:"视频中的画面是否清楚流畅？",version:'可用性评价规范1.0'},
    {id:'28',question_category:'3',desc:"视频中的声音是否自然流畅、易于理解？",version:'可用性评价规范1.0'},
    {id:'29',question_category:'3',desc:"动画中的画面或声音是否清楚？",version:'可用性评价规范1.0'},
    {id:'30',question_category:'3',desc:"媒体（图像、视频、动画和音频等）下载速度是否合理？",version:'可用性评价规范1.0'},
    {id:'31',question_category:'3',desc:"所有的媒体文件是否都能够正确下载并正确运行？",version:'可用性评价规范1.0'},
    {id:'32',question_category:'3',desc:"文本内容是否无较多语法、拼写、排版或者格式错误？",version:'可用性评价规范1.0'},
    {id:'33',question_category:'3',desc:"文本内容是否对于多数学习者来说是易辨认的？",version:'可用性评价规范1.0'},
    {id:'34',question_category:'4',desc:"是否对交流沟通渠道有清楚的表述？",version:'可用性评价规范1.0'},
    {id:'35',question_category:'4',desc:"是否对交流沟通的安排，如频率、时间、交流工具等方面的要求有清楚的表述？",version:'可用性评价规范1.0'},
    {id:'36',question_category:'4',desc:"沟通渠道是否畅通？",version:'可用性评价规范1.0'},
    {id:'37',question_category:'4',desc:"讨论区是否提供了必要的学习讨论功能？",version:'可用性评价规范1.0'},
    {id:'38',question_category:'4',desc:"讨论区是否容易使用？",version:'可用性评价规范1.0'},
    {id:'39',question_category:'4',desc:"直播课堂是否容易使用？",version:'可用性评价规范1.0'},
    {id:'40',question_category:'4',desc:"在线答疑是否容易使用？",version:'可用性评价规范1.0'},
    {id:'41',question_category:'4',desc:"是否提供了其他同学的联系方式？",version:'可用性评价规范1.0'},
    {id:'42',question_category:'4',desc:"聊天功能是否容易使用？",version:'可用性评价规范1.0'},
    {id:'43',question_category:'4',desc:"是否有多重渠道满足课程或者系统的使用者交流与沟通的需求？",version:'可用性评价规范1.0'},
    {id:'44',question_category:'4',desc:"是否能保证在交流沟通中，课程或者系统的使用者可以获得想要的信息？",version:'可用性评价规范1.0'},
    {id:'45',question_category:'5',desc:"是否有贯穿学习全程的课程进度指示的呈现？",version:'可用性评价规范1.0'},
    {id:'46',question_category:'5',desc:"课程进度指示的呈现是否清晰易于理解？",version:'可用性评价规范1.0'},
    {id:'47',question_category:'5',desc:"是否无论操作正确与否都有明确的反馈提示？",version:'可用性评价规范1.0'},
    {id:'48',question_category:'5',desc:"是否有必要的帮助信息？",version:'可用性评价规范1.0'},
    {id:'49',question_category:'5',desc:"是否提供了快捷方式能使熟练用户快速完成操作？",version:'可用性评价规范1.0'},
    {id:'50',question_category:'5',desc:"是否提供检索功能？",version:'可用性评价规范1.0'},
    {id:'51',question_category:'5',desc:"搜索内容是否方便？",version:'可用性评价规范1.0'},
    {id:'52',question_category:'5',desc:"搜索框的呈现位置是否合理，容易找到？",version:'可用性评价规范1.0'},
    {id:'53',question_category:'5',desc:"搜索结果的浏览方式是否良好？",version:'可用性评价规范1.0'},
    {id:'54',question_category:'5',desc:"是否有对学习过程的建议或引导？",version:'可用性评价规范1.0'},
    {id:'55',question_category:'5',desc:"是否有辅助学习者的辅导答疑服务？",version:'可用性评价规范1.0'},
    {id:'56',question_category:'5',desc:"是否有学习评价体系？",version:'可用性评价规范1.0'},
    {id:'57',question_category:'5',desc:"学习评价体系对学习者的学习是否有激励作用？",version:'可用性评价规范1.0'},
    {id:'58',question_category:'5',desc:"课程或者系统是否对学习者提供必要的操作支持，包括导航、技术支持和课程的一些特殊指令等？是否能记录学习者个阶段的学习成果？",version:'可用性评价规范1.0'},
    {id:'59',question_category:'5',desc:"是否提供上传下载功能？",version:'可用性评价规范1.0'},
    {id:'60',question_category:'6',desc:"各页面呈现的学习内容是否使用了用户语言？",version:'可用性评价规范1.0'},
    {id:'61',question_category:'6',desc:"各页面呈现的内容是否有层次感和吸引力且活动线索符合学习者认知习惯？",version:'可用性评价规范1.0'},
    {id:'62',question_category:'6',desc:"内容材料是否丰富和详细，并且和学习目标一致？",version:'可用性评价规范1.0'},
    {id:'63',question_category:'7',desc:"下载速度是否及时有效？",version:'可用性评价规范1.0'},
    {id:'64',question_category:'7',desc:"链接颜色是否常规合理？",version:'可用性评价规范1.0'},
    {id:'65',question_category:'7',desc:"导航页是否短小精悍？",version:'可用性评价规范1.0'},
    {id:'66',question_category:'7',desc:"网页长度是否适度（1-3屏间）？",version:'可用性评价规范1.0'},
    {id:'67',question_category:'7',desc:"是否不存在孤儿网页？",version:'可用性评价规范1.0'},
    {id:'68',question_category:'7',desc:"若课程中有插件，是否可实现自动下载安装？",version:'可用性评价规范1.0'},
    {id:'69',question_category:'7',desc:"是否适于不同的IE浏览器版本？",version:'可用性评价规范1.0'},
    {id:'70',question_category:'7',desc:"是否适于不同的浏览器？",version:'可用性评价规范1.0'}
])

puts "Importing lab_roles"
LabRole.delete_all
ActiveRecord::Base.connection.execute("alter table lab_roles auto_increment=1")
LabRole.create([{id:'1', name: '评测申请人',path:"apply_manage_lab_users_path"},
                {id:'2',name: '教师',path:"teacher_manage_lab_users_path"},
                {id:'3',name: '课程管理员',path:"course_manage_lab_users_path"},
                {id:'4',name: '实验室管理员',path:"lab_manage_lab_users_path"},
                {id:'5',name: '学生',path:"student_manage_lab_users_path"},
                {id:'6',name: '系统管理员',path:"system_manage_lab_users_path"}])

puts "Importing lab_users"
LabUser.delete_all
ActiveRecord::Base.connection.execute("alter table lab_users auto_increment=1")
LabUser.create([{name: 'apply',mobile: '15888801441',email: 'jason.chen@iotps.com',account: 'apply@iotps.com',password: 'e10adc3949ba59abbe56e057f20f883e',role_id: '1',status:'1'},
                {name: 'teacher',mobile: '15888801441',email: 'jason.chen@iotps.com',account: 'teacher@iotps.com',password: 'e10adc3949ba59abbe56e057f20f883e',role_id: '2',status:'1'},
                {name: 'course_admin',mobile: '15888801441',email: 'jason.chen@iotps.com',account: 'course_admin@iotps.com',password: 'e10adc3949ba59abbe56e057f20f883e',role_id: '3',status:'1'},
                {name: 'lab_admin',mobile: '15888801441',email: 'jason.chen@iotps.com',account: 'lab_admin@iotps.com',password: 'e10adc3949ba59abbe56e057f20f883e',role_id: '4',status:'1'},
                {name: 'student',mobile: '15888801441',email: 'jason.chen@iotps.com',account: 'student@iotps.com',password: 'e10adc3949ba59abbe56e057f20f883e',role_id: '5',status:'1'},
                {name: 'system',mobile: '15888801441',email: 'jason.chen@iotps.com',account: 'system@iotps.com',password: 'e10adc3949ba59abbe56e057f20f883e',role_id: '6',status:'1'}])

puts "Importing lab_equitments"
LabEquipment.delete_all
ActiveRecord::Base.connection.execute("alter table lab_equipments auto_increment=1")
LabEquipment.create([{id:'1',name:'体态监测01',equipment_code:'001001',position:'1',status:'1'},
                     {id:'2',name:'脑波监测01',equipment_code:'002001',position:'1',status:'1'},
                     {id:'3',name:'路由器01',equipment_code:'003001',position:'1',status:'1'},
                     {id:'4',name:'中控01',equipment_code:'004001',position:'1',status:'1'}
                    ])

puts "Importing lab_equitment_mapping"
LabEquipmentMapping.delete_all
ActiveRecord::Base.connection.execute("alter table lab_equipment_mappings auto_increment=1")
LabEquipmentMapping.create([{id:'1',equipment_code:'001001',table_name:'B000001',status:'0'},
                            {id:'2',equipment_code:'002001',table_name:'M000001',status:'0'},
                            {id:'3',equipment_code:'003001',table_name:'R000001',status:'0'},
                            {id:'4',equipment_code:'004001',table_name:'C000001',status:'0'}
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

puts "Importin lab_courses"
LabCourse.delete_all
ActiveRecord::Base.connection.execute("alter table lab_courses auto_increment=1")
LabCourse.create([{id:'1',name:'实验课堂教学1',category_id:'1',course_type:'1',teacher_id:'2',start_time:'2014-04-21 09:00',end_time:'2014-04-21 10:00',status:'1',project_id:'1',progress:'1',publish_time:'2014-04-01 10:00',scene_id:'1',is_teach:'1'},
                  {id:'2',name:'实验课堂教学2',category_id:'2',course_type:'2',teacher_id:'2',start_time:'2014-05-21 09:00',end_time:'2014-05-21 10:00',status:'1',project_id:'1',progress:'1',publish_time:'2014-04-01 10:00',scene_id:'1',is_teach:'1'}
                 ])

