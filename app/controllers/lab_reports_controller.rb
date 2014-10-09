#encoding:utf-8
require 'pp'
require 'htmltoword'
require 'wicked_pdf'
require 'prawn'
require 'axlsx'

class LabReportsController < ApplicationController

  # GET /lab_reports
  # GET /lab_reports.json
  layout "blank"#,:except => [:show]

  def export_excel
    course_id =params[:id]
    @data = LabDataMinute.where(:course_id=>course_id)

    if @data.size==0
       source = 1
       source_max = 4
       @lab_course= LabCourse.find(course_id)
       begin_time  = @lab_course.begin_time_real.strftime('%Y%m%d%H%M%S')
       end_time = @lab_course.end_time_real.strftime('%Y%m%d%H%M%S')

       while source <= source_max  do
         #注意力
         # return render  :text=> sql
         sql =" INSERT lab_development.lab_data_minutes (read_at,attention,course_id,source)
        SELECT minute,value,#{course_id},'#{source}' from lab_development.M000001_minute
        where source='#{source}' and point_id='000000' and  minute>='#{begin_time}' and minute<='#{end_time}'; "
         ActiveRecord::Base.connection.execute(sql)
          #放松度
          sql =" UPDATE lab_development.lab_data_minutes INNER JOIN lab_development.M000001_minute
       ON lab_development.lab_data_minutes.read_at = lab_development.M000001_minute.minute
AND lab_development.lab_data_minutes.source = lab_development.M000001_minute.source
       SET lab_development.lab_data_minutes.meditation = lab_development.M000001_minute.value
       where lab_development.M000001_minute.source='#{source}' and lab_development.M000001_minute.point_id='000001'
       AND lab_development.M000001_minute.minute>='#{begin_time}' and lab_development.M000001_minute.minute<='#{end_time}'; "
          ActiveRecord::Base.connection.execute(sql)
          #行为体态
          sql ="UPDATE lab_development.lab_data_minutes INNER JOIN lab_development.B000001_minute
     ON lab_development.lab_data_minutes.read_at = lab_development.B000001_minute.minute
    AND lab_development.lab_data_minutes.source = lab_development.B000001_minute.source
    SET lab_development.lab_data_minutes.behaviour = lab_development.B000001_minute.value/80
    where lab_development.B000001_minute.source='#{source}' and lab_development.B000001_minute.point_id='000000'
    and  lab_development.B000001_minute.minute>='#{begin_time}' and lab_development.B000001_minute.minute<='#{end_time}'; "
          ActiveRecord::Base.connection.execute(sql)
          #终端网络数据
         sql ="UPDATE lab_development.lab_data_minutes INNER JOIN lab_development.R000001_minute
     ON lab_development.lab_data_minutes.read_at = lab_development.R000001_minute.minute
    AND lab_development.lab_data_minutes.source = lab_development.R000001_minute.source
    SET lab_development.lab_data_minutes.behaviour = lab_development.R000001_minute.value
    where lab_development.R000001_minute.source='#{source}' and lab_development.R000001_minute.point_id='000001'
    and  lab_development.R000001_minute.minute>='#{begin_time}' and lab_development.R000001_minute.minute<='#{end_time}'; "
         ActiveRecord::Base.connection.execute(sql)
          source +=1
       end
       #网络上行
       sql ="UPDATE lab_development.lab_data_minutes INNER JOIN lab_development.R000001_minute
     ON lab_development.lab_data_minutes.read_at = lab_development.R000001_minute.minute
 AND lab_development.lab_data_minutes.source = lab_development.R000001_minute.source
    SET lab_development.lab_data_minutes.network_up = lab_development.R000001_minute.value
    where lab_development.R000001_minute.point_id='000001'
    and  lab_development.R000001_minute.minute>='#{begin_time}' and lab_development.R000001_minute.minute<='#{end_time}'; "
     #  ActiveRecord::Base.connection.execute(sql)
       #网络下行
       sql ="UPDATE lab_development.lab_data_minutes INNER JOIN lab_development.R000001_minute
     ON lab_development.lab_data_minutes.read_at = lab_development.R000001_minute.minute
 AND lab_development.lab_data_minutes.source = lab_development.R000001_minute.source
    SET lab_development.lab_data_minutes.network_down = lab_development.R000001_minute.value
    where lab_development.R000001_minute.point_id='000002'
    and  lab_development.R000001_minute.minute>='#{begin_time}' and lab_development.R000001_minute.minute<='#{end_time}'; "
      # ActiveRecord::Base.connection.execute(sql)
       #能耗
       sql ="UPDATE lab_development.lab_data_minutes INNER JOIN lab_development.C000001_minute
     ON lab_development.lab_data_minutes.read_at = lab_development.C000001_minute.minute
    SET lab_development.lab_data_minutes.energy_consumption = lab_development.C000001_minute.value
    where lab_development.C000001_minute.point_id='000001'
    and  lab_development.C000001_minute.minute>='#{begin_time}' and lab_development.C000001_minute.minute<='#{end_time}'; "
       ActiveRecord::Base.connection.execute(sql)
       #设备温度
       sql ="UPDATE lab_development.lab_data_minutes INNER JOIN lab_development.C000001_minute
     ON lab_development.lab_data_minutes.read_at = lab_development.C000001_minute.minute
 AND lab_development.lab_data_minutes.source = lab_development.C000001_minute.source
    SET lab_development.lab_data_minutes.temperature = lab_development.C000001_minute.value
    where lab_development.C000001_minute.point_id='000002'
    and  lab_development.C000001_minute.minute>='#{begin_time}' and lab_development.C000001_minute.minute<='#{end_time}'; "
       ActiveRecord::Base.connection.execute(sql)
       #湿度
       sql ="UPDATE lab_development.lab_data_minutes INNER JOIN lab_development.C000001_minute
     ON lab_development.lab_data_minutes.read_at = lab_development.C000001_minute.minute
 AND lab_development.lab_data_minutes.source = lab_development.C000001_minute.source
    SET lab_development.lab_data_minutes.humidity = lab_development.C000001_minute.value
    where lab_development.C000001_minute.point_id='000003'
    and  lab_development.C000001_minute.minute>='#{begin_time}' and lab_development.C000001_minute.minute<='#{end_time}'; "
       ActiveRecord::Base.connection.execute(sql)
       @data = LabDataMinute.where(:course_id=>course_id).order(read_at: :asc)
    end

    package = Axlsx::Package.new
    workbook = package.workbook
    workbook.styles do |s|
      head_cell = s.add_style  :b=>true, :sz => 10, :alignment => { :horizontal => :center,
                                                                    :vertical => :center},:height=> 20
      goods_cell = s.add_style :b=>true, :sz => 10, :alignment => {:vertical => :center},:height=> 20

      workbook.add_worksheet(:name => "Report") do |sheet|
        date=''
        if @data.first
          date = @data.first.read_at[0..7]
          date = date[0..3] + "-"+ date[4..5] + "-"+ date[6..7]
        end
        sheet.add_row ["(测试日期:#{date})"],:style=>goods_cell

        sheet.add_row ['时间',"注意力","放松度","体态","网络上行","网络下行","能耗","温度","湿度","学生"],
                      :style=>head_cell

        row_count=0

        @data.each do |d|
          times = d.read_at[8..12]
          times = times[0..1] + ":"+times[2..3]
          sheet.add_row [times,d.attention,d.meditation,d.behaviour,d.network_up,d.network_down,d.energy_consumption,d.temperature,d.humidity,d.source],
                        :style=>goods_cell

          row_count +=1

      #    sheet.column_widths nil, nil,nil,nil,nil,10
        end
      end
    end

    send_data package.to_stream.read,:filename=>"original_data_report_#{Time.now.strftime('%Y%m%d%H%M%S')}.xlsx"
  end

  def export
    id=params[:id]
    @lab_course = LabCourse.find(id)

    source_max = 4
    getvalues = ['max','min','avg']

    behaviour=Hash.new
    getvalues.each do |getvalue|
      students = Array.new(5)
      source = 1
      while source<=source_max do
        sql = "select #{getvalue}(behaviour) as value from lab_development.lab_data_minutes where course_id =#{id} and source='#{source}';"

        results = ActiveRecord::Base.connection.execute(sql)
        results.each(:as => :hash) do |row|
          students[source]= format('%.2f',row["value"]) if row["value"]
        end
        source += 1
      end
      behaviour[getvalue] = students
    end

    attention = Hash.new
    getvalues.each do |getvalue|
      students = Array.new(5)
      source = 1
      while source<=source_max do
        sql = "select #{getvalue}(attention) as value from lab_development.lab_data_minutes where course_id =#{id} and source='#{source}';"
        results = ActiveRecord::Base.connection.execute(sql)
        results.each(:as => :hash) do |row|

          students[source]= format('%.2f',row["value"]) if  row["value"]
        end
        source += 1
      end
      attention[getvalue] = students
    end

    meditation = Hash.new
    getvalues.each do |getvalue|
      students = Array.new(5)
      source = 1
      while source<=source_max do
        sql = "select #{getvalue}(meditation) as value from lab_development.lab_data_minutes where course_id =#{id} and source='#{source}';"
        results = ActiveRecord::Base.connection.execute(sql)
        results.each(:as => :hash) do |row|
            students[source]= format('%.2f',row["value"]) if row["value"]
        end
        source += 1
      end
      meditation[getvalue] = students
    end

    #@app_test =AppTest.where(:course_id=>id).limit(0,4)
    @app_test =AppTest.limit(4)
    students_score=''
    i = 0
    @app_test.each do |app_test|
      i= i+1
      if i==2 || i==3
        colspan='2'
      else
        colspan='1'
      end
      students_score= students_score +%Q{
      <td style="width:106px;" colspan="#{colspan}">
        <p align="center"></p>
      </td>
     }
    end

      html_head=%Q{<!DOCTYPE html><html><head>
    <meta http-equiv=Content-Type content="text/html; charset=utf-8">
<style>
body {font-family:"Microsoft Yahei", "SimHei"}
p {font-family:"Microsoft Yahei", "SimHei"}
</style>
</head><body><p style='margin-left:21.0pt;font-family:"Microsoft Yahei", "SimHei"'>
<p><img src='file:///root/lab/app/assets/images/logo.png' style="width:60px;">开放教学数字化实验室</p>
}

html_common_1=%Q{
<table border="1" cellpadding="0" cellspacing="0" width="100%">
<tbody>
<tr>
  <td colspan="7" style="width:553px;;background-color:#66B3FF">
    <p align="center">
      <strong>基本信息</strong></p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p align="center">
      <strong>测试项目名称</strong></p>
  </td>
  <td colspan="6" style="width:423px;">
    <p align="center">#{@lab_course.lab_eval_project.name}</p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p align="center">
      <strong>申请单位</strong></p>
  </td>
  <td colspan="6" style="width:423px;">
    <p align="center">#{@lab_course.lab_eval_project.unit}</p>
  </td>
</tr>
<tr>
  <td style="width:130px;text-align:center">
    <p>
      <strong>申请单位联系人</strong></p>
  </td>
  <td colspan="2" style="width:151px;text-align:center">
    <p>#{@lab_course.lab_eval_project.lab_user.name}</p>
  </td>
  <td colspan="2" style="width:76px;text-align:center">
    <p>
      <strong>联系方式</strong></p>
  </td>
  <td colspan="2" style="width:196px;text-align:center">
    <p>电话： #{@lab_course.lab_eval_project.lab_user.mobile} / #{@lab_course.lab_eval_project.lab_user.email}</p>
  </td>
</tr>
<tr>
  <td style="width:130px;text-align:center">
    <p><strong>申请时间</strong></p>
  </td>
  <td colspan="2" style="width:151px;text-align:center">
    <p>#{@lab_course.lab_eval_project.created_at.strftime('%Y-%m-%d %H:%M:%S')}</p>
  </td>
  <td colspan="2" style="width:76px;text-align:center">
    <p><strong>版本</strong></p>
  </td>
  <td colspan="2" style="width:196px;text-align:center">
    <p>#{@lab_course.lab_eval_project.version}</p>
  </td>
</tr>
<tr>
  <td colspan="7" style="width:553px;background-color:#66B3FF"">
    <p align="center">
      <strong>项目背景</strong></p>
  </td>
</tr>
<tr>
  <td style="width:130px;text-align:center">
    <p><strong>测试目标</strong></p>
  </td>
  <td colspan="6" style="width:423px;text-align:center">
    <p align="center">#{@lab_course.lab_eval_project.brief}</p>
  </td>
</tr>
<tr>
  <td style="width:130px;text-align:center">
    <p><strong>课程名称</strong></p>
  </td>
  <td colspan="6" style="width:423px;">
    <p align="center">#{@lab_course.name}</p>
  </td>
</tr>
<tr>
  <td style="width:130px;text-align:center">
    <p><strong>测试地点</strong></p>
  </td>
  <td colspan="6" style="width:423px;">
    <p align="center">#{@lab_course.location}</p>
  </td>
</tr>
<tr>
  <td style="width:130px;text-align:center">
    <p><strong>参与人员</strong></p>
  </td>
  <td colspan="6" style="width:423px;">
    <p align="center">#{@lab_course.participants}</p>
  </td></tr></tbody></table>
<br/><br/><br/><br/><br><br/><br/><br/><br>

<table border="1" cellpadding="0" cellspacing="0" width="100%"><tbody>
<tr>
  <td style="width:553px;background-color:#66B3FF"">
    <p align="center">
      <strong>测试流程</strong></p>
  </td>
</tr>
  <td>
    <p align="center"><img src='file:///root/lab/app/assets/images/evalue_flow.jpg' style="width:100%;">
  </p>
  </td>
</tr>
</tr></tbody></table>}

    html_common_2=%Q{<table border="1" cellpadding="0" cellspacing="0" width="100%"><tbody>
<tr>
  <td colspan="7" style="width:553px;background-color:#66B3FF"">
    <p align="center">
      <strong>测试结果</strong></p>
  </td>
</tr>
<tr>
  <td style="width:130px;text-align:center">
    <p><strong>测试时间区间</strong></p>
  </td>
  <td colspan="6" style="width:423px;text-align:center">
    <p>#{@lab_course.begin_time_real.strftime('%Y-%m-%d %H:%M:%S')} -- #{@lab_course.end_time_real.strftime('%Y-%m-%d %H:%M:%S')}</p>
  </td>
</tr>
<tr>
  <td style="width:130px;text-align:center">
    <p><strong>测试情景</strong></p>
  </td>
  <td colspan="6" style="width:423px;">
    <p align="center">#{@lab_course.lab_scene.name}</p>
  </td>
</tr>
<tr>
  <td colspan="7" style="width:553px;background-color:#66B3FF"">
    <p align="center">
      <strong>无线网络使用分析图表</strong></p>
  </td>
</tr>
<tr>
  <td colspan="7" style="width:553px;">
<p><img src='file:///root/lab/public/report/network#{id}.jpg' style="width:100%;"></p>

  </td>
</tr>
<tr>
<tr>
  <td style="width:130px;text-align:center">
    <p><strong>实验对象抽样</strong></p>
  </td>
  <td style="width:106px;text-align:center">
    <p><strong>学生1</strong></p>
  </td>
  <td colspan="2" style="width:106px;text-align:center">
    <p<strong>学生2</strong></p>
  </td>
  <td colspan="2" style="width:106px;text-align:center">
    <p ><strong>学生3</strong></p>
  </td>
  <td style="width:106px;text-align:center">
    <p ><strong>学生4</strong></p>
  </td>
</tr>
<tr>
  <td style="width:130px;text-align:center">
    <p><strong>教学效果</strong></p>
  </td>
  #{students_score}
</tr></tbody></table>}

   title_behaviours="<hr/><p style='text-align:center;font-size:12pt;'>实验室行为体态分析评测报告</p>"
    html_behaviour_0=%Q{<table border="1" cellpadding="0" cellspacing="0" width="100%"><tbody>
<tr>
  <td style="width:130px;text-align:center">
    <p><strong>测试方法</strong></p>
  </td>
  <td colspan="6" style="width:423px;">
    <p align="center">采集学生在课堂的行为体态图像数据，进行分析</p>
  </td>
</tr>
<tr>
  <td style="width:130px;text-align:center">
    <p><strong>测试内容</strong></p>
  </td>
  <td colspan="6" style="width:423px;">
    <p align="center">学生在课堂的行为体态</p>
  </td>
</tr></tbody></table>}


html_behaviour_1=%Q{<table border="1" cellpadding="0" cellspacing="0" width="100%"><tbody>
<tr>
  <td style="width:130px;text-align:center">
    <p><strong>实验对象抽样</strong></p>
  </td>
  <td style="width:106px;text-align:center">
    <p><strong>学生1</strong></p>
  </td>
  <td colspan="2" style="width:106px;text-align:center">
    <p<strong>学生2</strong></p>
  </td>
  <td colspan="2" style="width:106px;text-align:center">
    <p ><strong>学生3</strong></p>
  </td>
  <td style="width:106px;text-align:center">
    <p ><strong>学生4</strong></p>
  </td>
</tr>

<tr>
  <td style="width:130px;text-align:center">
    <p><strong>课堂最高安静指数</strong></p>
  </td>
  <td style="width:106px;">
    <p align="center">#{behaviour["max"][1]}</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">#{behaviour["max"][2]}</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">#{behaviour["max"][3]}</p>
  </td>
  <td style="width:106px;">
    <p align="center">#{behaviour["max"][4]}</p>
  </td>
</tr>
<tr>
  <td style="width:130px;text-align:center">
    <p><strong>课堂最低安静指数</strong></p>
  </td>
  <td style="width:106px;">
    <p align="center">#{behaviour["min"][1]}</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">#{behaviour["min"][2]}</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">#{behaviour["min"][3]}</p>
  </td>
  <td style="width:106px;">
    <p align="center">#{behaviour["min"][4]}</p>
  </td>
</tr>
<tr>
  <td style="width:130px;text-align:center">
    <p><strong>课堂平均安静指数</strong></p>
  </td>
  <td style="width:106px;text-align:center">
    <p align="center">#{behaviour["avg"][1]}</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">#{behaviour["avg"][2]}</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">#{behaviour["avg"][3]}</p>
  </td>
  <td style="width:106px;">
    <p align="center">#{behaviour["avg"][4]}</p>
  </td>
</tr>
<tr>
  <td colspan="7" style="width:553px;background-color:#66B3FF"">
    <p align="center">
      <strong>课堂行为体态分析图表</strong></p>
  </td>
</tr>
<tr>
  <td colspan="7" style="width:553px;">
<p><img src='file:///root/lab/public/report/behaviour#{id}.jpg' style="width:100%;"></p>

  </td>
</tr>
<tr>
  <td colspan="7" style="width:553px;background-color:#66B3FF"">
    <p align="center" style="margin-left:31.5pt;">
      <strong>意见和建议</strong></p>
  </td>
</tr>
<tr>
  <td colspan="7" style="width:553px;">
<p style="margin-left:31.5pt;">
      <strong>平均值<30，说明被测学生在课堂上行为体态较为安静</strong></p>
    <p style="margin-left:31.5pt;">
      <strong>50>=平均值>=30，说明被测学生在课堂上行为体态较为活跃</strong></p>
<p style="margin-left:31.5pt;">
      <strong>平均值>50，说明被测学生在课堂上行为体态活跃</strong></p>
  </td>
</tr>
<tr>
  <td colspan="7" style="width:553px;">
    <p style="margin-left:31.5pt;">
      <strong>#{@lab_course.opinion}</strong></p>
  </td>
</tr>
</tbody>
</table><br/><br/><br/><br/>}

title_mindwave=%Q{<hr/><p style="margin-left:21.0pt;text-align:center;font-size:12pt;">实验室脑波评测报告</p><p>  &nbsp;</p>}

html_mindwave_0=%Q{<table border="1" cellpadding="0" cellspacing="0" width="100%"><tbody>
<tr>
<td style="width:130px;text-align:center">
    <p><strong>测试方法</strong></p>
  </td>
  <td colspan="6" style="width:423px;">
    <p>1	可以对实验课程中的学生的脑波数据进行抽样采集；</p>
<p>2	学生戴上脑波监测设备，数据通过无线设备传回服务器;</p>
<p>3	对采集到的 delta波、theta波、lowAlpha波、highAlpha波、lowBeta波、highBeta波、lowGamma波、highGamma波、眨眼次数等数据进行分析，
得出被测学生的注意力指数、放松度指数。
</p>
  </td>
</tr>
<tr>
  <td style="width:130px;text-align:center">
    <p><strong>测试内容</strong></p>
  </td>
  <td colspan="6" style="width:423px;">
    <p align="center">脑波分析</p>
  </td>
</tr></tbody></table>}
html_mindwave_1=%Q{<table border="1" cellpadding="0" cellspacing="0" width="100%"><tbody>
<tr>
  <td style="width:130px;text-align:center">
    <p><strong>实验对象抽样</strong></p>
  </td>
  <td style="width:106px;text-align:center">
    <p><strong>学生1</strong></p>
  </td>
  <td colspan="2" style="width:106px;text-align:center">
    <p<strong>学生2</strong></p>
  </td>
  <td colspan="2" style="width:106px;text-align:center">
    <p ><strong>学生3</strong></p>
  </td>
  <td style="width:106px;text-align:center">
    <p ><strong>学生4</strong></p>
  </td>
</tr>

<tr>
  <td style="width:130px;text-align:center">
    <p><strong>专注度最高值</strong></p>
  </td>
  <td style="width:106px;">
    <p align="center">#{attention["max"][1]}</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">#{attention["max"][2]}</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">#{attention["max"][3]}</p>
  </td>
  <td style="width:106px;">
    <p align="center">#{attention["max"][4]}</p>
  </td>
</tr>
<tr>
  <td style="width:130px;text-align:center">
    <p><strong>专注度最低值</strong></p>
  </td>
  <td style="width:106px;">
    <p align="center">#{attention["min"][1]}</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">#{attention["min"][2]}</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">#{attention["min"][3]}</p>
  </td>
  <td style="width:106px;">
    <p align="center">#{attention["min"][4]}</p>
  </td>
</tr>
<tr>
  <td style="width:130px;text-align:center">
    <p><strong>专注度平均值</strong></p>
  </td>
  <<td style="width:106px;">
    <p align="center">#{attention["avg"][1]}</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">#{attention["avg"][2]}</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">#{attention["avg"][3]}</p>
  </td>
  <td style="width:106px;">
    <p align="center">#{attention["avg"][4]}</p>
  </td>
</tr>
<tr>
  <td style="width:130px;text-align:center">
    <p><strong>放松度最高值</strong></p>
  </td>
  <td style="width:106px;">
    <p align="center">#{meditation["max"][1]}</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">#{meditation["max"][2]}</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">#{meditation["max"][3]}</p>
  </td>
  <td style="width:106px;">
    <p align="center">#{meditation["max"][4]}</p>
  </td>
</tr>
<tr>
  <td style="width:130px;text-align:center">
    <p><strong>放松度最低值</strong></p>
  </td>
   <td style="width:106px;">
    <p align="center">#{meditation["min"][1]}</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">#{meditation["min"][2]}</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">#{meditation["min"][3]}</p>
  </td>
  <td style="width:106px;">
    <p align="center">#{meditation["min"][4]}</p>
  </td>
</tr>
<tr>
  <td style="width:130px;text-align:center">
    <p><strong>放松度平均值</strong></p>
  </td>
   <td style="width:106px;">
    <p align="center">#{meditation["avg"][1]}</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">#{meditation["avg"][2]}</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">#{meditation["avg"][3]}</p>
  </td>
  <td style="width:106px;">
    <p align="center">#{meditation["avg"][4]}</p>
  </td>
</tr>
<tr>
  <td colspan="7" style="width:553px;background-color:#66B3FF">
    <p align="center">
      <strong>注意力脑波分析图表</strong></p>
  </td>
</tr>
<tr>
  <td colspan="7" style="width:100%;">
    <p><img src='file:///root/lab/public/report/attention#{id}.jpg' style="width:100%;"></p>
  </td>
</tr>
<tr>
  <td colspan="7" style="width:553px;background-color:#66B3FF">
    <p align="center">
      <strong>放松度脑波分析图表</strong></p>
  </td>
</tr>
<tr>
  <td colspan="7" style="width:100%;">
    <p><img src='file:///root/lab/public/report/meditation#{id}.jpg' style="width:100%;"></p>
  </td>
</tr>
<tr>
  <td colspan="7" style="width:553px;background-color:#66B3FF"">
    <p align="center" style="margin-left:31.5pt;">
      <strong>意见和建议</strong></p>
  </td>
</tr>
<tr>
  <td colspan="7" style="text-align:center">
    <p style="margin-left:31.5pt;">放松度指数与注意力之间的关系</p>
<p>	X=放松度小于40的时长 / 全部时间 * 100</p>
<p>
<table border="1" cellpadding="0" cellspacing="0" style="width:80%">
	<tbody>
		<tr>
			<td style="width:277px;">
				<p>
					X &gt;= 25</p>
			</td>
			<td style="width:277px;">
				<p>
					注意力低下&mdash; 紧张、压力大</p>
			</td>
		</tr>
		<tr>
			<td style="width:277px;">
				<p>
					10 &lt;&nbsp; X&lt;&nbsp; 25</p>
			</td>
			<td style="width:277px;">
				<p>
					注意力正常 &ndash; 平静</p>
			</td>
		</tr>
		<tr>
			<td style="width:277px;">
				<p>
					X &lt;=10</p>
			</td>
			<td style="width:277px;">
				<p>
					注意力高度集中 &ndash; 非常平静</p>
			</td>
		</tr>
	</tbody>
</table></p>
  </td>
</tr></tbody></table><br/><br/><br/><br/>}

    title_questions=%Q{<hr/><p style="margin-left:21.0pt;text-align:center;font-size:12pt;"> 实验室评测问卷调查报告</p>}
    html_questions=%Q{<table border="1" cellpadding="0" cellspacing="0" width="100%"><tbody>}

    @lab_questions = LabQuestion
    @question_categories = Option.question_category

  #  @lab_questions_score = LabQuestionsScore.find(params[:id])
    @question_categories.each do |category|
      html_questions = html_questions+ %Q{<tr><td style="width:50px;text-align:center;background-color:#66B3FF">&nbsp;#{category.value}.</td>
      <td style="text-align:center;background-color:#66B3FF">#{category.name}</td>
    <td style="width:80px;text-align:center;background-color:#66B3FF">重要性</td>
  <td style="width:80px;text-align:center;background-color:#66B3FF">得分<td></tr>
        <tr><td colspan="4">#{category.desc}</td><tr>}
        @lab_questions.where(:question_category=>category.value).each do |question|
          html_questions = html_questions+ %Q{<tr><td style="text-align:right;line-height:30px;">#{question.id}.&nbsp;&nbsp;</td><td>&nbsp;#{question.desc}</td>
      <td style="text-align:center">#{(rand*3).to_i}</td><td style="text-align:center">#{(rand*7).to_i}</td></tr>}
        end
    end
    html_questions = html_questions + %Q{<tr><td colspan="2" style="text-align:center">综合得分：</td>
    <td colspan="2" style="text-align:center">#{(rand*100).to_i}</td></tr></tbody></table>}

  title_comprehensive=%Q{<hr/><p style="margin-left:21.0pt;text-align:center;font-size:12pt;">
  教学资源/电子书包实验室评测总报告</p>}
    html_foot=%Q{</body></html>}
    title=params["title"]
    case title
      when 'behaviour'
        html=html_head + title_behaviours + html_common_1 + html_behaviour_0 + html_common_2 + html_behaviour_1 + html_foot
      when 'mindwave'
        html=html_head + title_mindwave + html_common_1 + html_mindwave_0 + html_common_2 + html_mindwave_1 +  html_foot
      when 'questions'
        html=html_head + title_questions + html_questions + html_foot
      else
        html=html_head + title_comprehensive + html_common_1 + html_common_2+ title_behaviours + html_behaviour_0 + html_behaviour_1+ title_mindwave+ html_mindwave_0+ html_mindwave_1 + html_foot
    end

   # return render :text=>html
    pdf = WickedPdf.new.pdf_from_string(html)
    save_path = "#{PIC_PATH}/teachResources/reports/report_#{title}_#{id}.pdf"
    File.open(save_path, 'wb') do |file|
      file << pdf
    end
    @title=title
    @id=id

  end

  def search
    @action='/lab_reports/0/search'
    @key=params[:key]

    @lab_reports =  LabReport.paginate(:page => params[:page], :per_page => 5).order("created_at DESC")
    if @key
      @lab_reports =@lab_reports.where("name like '%#{@key}%'")
    end
    render 'lab_reports/index'
  end

  def index
    @action='/lab_reports/0/search'
    @lab_reports = LabReport.paginate(:page => params[:page], :per_page => 5).order("created_at DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @lab_reports }
    end
  end

  # GET /lab_reports/1
  # GET /lab_reports/1.json
  def show
    @id = params[:id]


   # @lab_report =  LabReport.find(@id)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lab_report }
    end
  end

  # GET /lab_reports/new
  # GET /lab_reports/new.json
  def new
    @lab_report = LabReport.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @lab_report }
    end
  end

  # GET /lab_reports/1/edit
  def edit
    @lab_report = LabReport.find(params[:id])
  end

  # POST /lab_reports
  # POST /lab_reports.json
  def create
    @lab_report = LabReport.new(params[:lab_report])

    respond_to do |format|
      if @lab_report.save
        format.html { redirect_to @lab_report, notice: 'Lab report was successfully created.' }
        format.json { render json: @lab_report, status: :created, location: @lab_report }
      else
        format.html { render action: "new" }
        format.json { render json: @lab_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /lab_reports/1
  # PUT /lab_reports/1.json
  def update
    @lab_report = LabReport.find(params[:id])

    respond_to do |format|
      if @lab_report.update_attributes(params[:lab_report])
        format.html { redirect_to @lab_report, notice: 'Lab report was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @lab_report.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lab_reports/1
  # DELETE /lab_reports/1.json
  def destroy
    @lab_report = LabReport.find(params[:id])
    @lab_report.destroy

    respond_to do |format|
      format.html { redirect_to lab_reports_url }
      format.json { head :no_content }
    end
  end
end
