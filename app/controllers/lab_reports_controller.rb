#encoding:utf-8
require 'pp'
require 'htmltoword'
require 'wicked_pdf'
require 'prawn'

class LabReportsController < ApplicationController
  # GET /lab_reports
  # GET /lab_reports.json
  layout "blank"#,:except => [:show]

  def export
    id=params[:id]
    @lab_course = LabCourse.find(id)
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
        <p align="center">#{app_test.score}</p>
      </td>
     }
    end

      html_head=%Q{<!DOCTYPE html><html><head>
    <meta http-equiv=Content-Type content="text/html; charset=utf-8">
</head><body><p style="margin-left:21.0pt;">
<p><img src='file:///root/lab/app/assets/images/logo.png' style="width:60px;">上海开放大学 </p>}

html_common_1=%Q{
<table border="1" cellpadding="0" cellspacing="0" width="100%">
<tbody>
<tr>
  <td colspan="7" style="width:553px;">
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
  <td colspan="2" style="width:151px;">
    <p>#{@lab_course.lab_eval_project.lab_user.name}</p>
  </td>
  <td colspan="2" style="width:76px;">
    <p>
      <strong>联系方式</strong></p>
  </td>
  <td colspan="2" style="width:196px;">
    <p>#{@lab_course.lab_eval_project.lab_user.mobile} / #{@lab_course.lab_eval_project.lab_user.email}</p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p align="center">
      <strong>申请时间</strong></p>
  </td>
  <td colspan="2" style="width:151px;">
    <p>#{@lab_course.lab_eval_project.created_at}</p>
  </td>
  <td colspan="2" style="width:76px;">
    <p>
      <strong>版本</strong></p>
  </td>
  <td colspan="2" style="width:196px;">
    <p>#{@lab_course.lab_eval_project.version}</p>
  </td>
</tr>
<tr>
  <td colspan="7" style="width:553px;">
    <p align="center">
      <strong>项目背景</strong></p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p align="center">
      <strong>测试目标</strong></p>
  </td>
  <td colspan="6" style="width:423px;">
    <p align="center">#{@lab_course.lab_eval_project.brief}</p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p align="center">
      <strong>课程名称</strong></p>
  </td>
  <td colspan="6" style="width:423px;">
    <p align="center">#{@lab_course.name}</p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p align="center">
      <strong>测试地点</strong></p>
  </td>
  <td colspan="6" style="width:423px;">
    <p align="center">#{@lab_course.location}</p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p align="center">
      <strong>参与人员</strong></p>
  </td>
  <td colspan="6" style="width:423px;">
    <p align="center">#{@lab_course.participants}</p>
  </td>
</tr></tbody></table>}
    html_common_2=%Q{<table border="1" cellpadding="0" cellspacing="0" width="100%"><tbody>
<tr>
  <td colspan="7" style="width:553px;">
    <p align="center">
      <strong>测试结果</strong></p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p>
      <strong>测试时间区间</strong></p>
  </td>
  <td colspan="6" style="width:423px;">
    <p align="center">#{@lab_course.start_time} -- #{@lab_course.end_time}</p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p>
      <strong>测试情景</strong></p>
  </td>
  <td colspan="6" style="width:423px;">
    <p align="center">#{@lab_course.lab_scene.name}</p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p>
      <strong>无线网络总流量</strong></p>
  </td>
  <td colspan="6" style="width:423px;">
    <p align="center"> 49.2MB</p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p>
      <strong>实验对象抽样</strong></p>
  </td>
  <td style="width:106px;">
    <p align="center">
      <strong>学生1</strong></p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">
      <strong>学生2</strong></p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">
      <strong>学生3</strong></p>
  </td>
  <td style="width:106px;">
    <p align="center">
      <strong>学生4</strong></p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p>
      <strong>教学效果</strong></p>
  </td>
  #{students_score}
</tr></tbody></table>}

   title_behaviours="<p>一、教学资源实验室体态分析评测报告</p>"
    html_behaviour_0=%Q{<table border="1" cellpadding="0" cellspacing="0" width="100%"><tbody>
<tr>
  <td style="width:130px;">
    <p align="center">
      <strong>测试流程</strong></p>
  </td>
  <td colspan="6" style="width:423px;">
    <p align="center">采集学生在课堂的行为体态图像数据，进行分析</p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p align="center">
      <strong>测试内容</strong></p>
  </td>
  <td colspan="6" style="width:423px;">
    <p align="center">学生在课堂的行为体态表现</p>
  </td>
</tr></tbody></table>}


html_behaviour_1=%Q{<table border="1" cellpadding="0" cellspacing="0" width="100%"><tbody>
<tr>
  <td style="width:130px;">
    <p>
      <strong>课堂最高安静指数</strong></p>
  </td>
  <td style="width:106px;">
    <p align="center">94</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">93</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">88</p>
  </td>
  <td style="width:106px;">
    <p align="center">99</p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p>
      <strong>课堂最低安静指数</strong></p>
  </td>
  <td style="width:106px;">
    <p align="center">24</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">41</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">34</p>
  </td>
  <td style="width:106px;">
    <p align="center">11</p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p>
      <strong>课堂平均安静指数</strong></p>
  </td>
  <td style="width:106px;">
    <p align="center">72</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">46</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">58</p>
  </td>
  <td style="width:106px;">
    <p align="center">39</p>
  </td>
</tr>
<tr>
  <td colspan="7" style="width:553px;">
    <p align="center">
      <strong>图表</strong></p>
  </td>
</tr>
<tr>
  <td colspan="7" style="width:553px;">
<p><img src='file:///root/pics/teachResources/reports/charts/behaviour.JPG' style="width:100%;"></p>

  </td>
</tr>
<tr>
  <td colspan="7" style="width:553px;">
    <p align="center" style="margin-left:31.5pt;">
      <strong>意见和建议</strong></p>
  </td>
</tr>
<tr style="display:none">
  <td colspan="7" style="width:553px;">
    <p style="margin-left:31.5pt;">
      <strong>注：根据页面输入填写该部分内容</strong></p>
  </td>
</tr>
</tbody>
</table>}

    title_mindwave=%Q{<p style="margin-left:21.0pt;">
  教学资源实验室脑波评测报告</p><p>  &nbsp;</p>}

html_mindwave_0=%Q{<table border="1" cellpadding="0" cellspacing="0" width="100%"><tbody>
<tr>
<td style="width:130px;">
    <p align="center">
      <strong>测试流程</strong></p>
  </td>
  <td colspan="6" style="width:423px;">
    <p align="center"> </p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p align="center">
      <strong>测试内容</strong></p>
  </td>
  <td colspan="6" style="width:423px;">
    <p align="center">脑波分析</p>
  </td>
</tr></tbody></table>}
html_mindwave_1=%Q{<table border="1" cellpadding="0" cellspacing="0" width="100%"><tbody>
<tr>
  <td style="width:130px;">
    <p>
      <strong>专注度最高值</strong></p>
  </td>
  <td style="width:106px;">
    <p align="center">100</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">100</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">89</p>
  </td>
  <td style="width:106px;">
    <p align="center">95</p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p>
      <strong>专注度最低值</strong></p>
  </td>
  <td style="width:106px;">
    <p align="center">24</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">0</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">12</p>
  </td>
  <td style="width:106px;">
    <p align="center">3</p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p>
      <strong>专注度平均值</strong></p>
  </td>
  <td style="width:106px;">
    <p align="center">46</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">57</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">69</p>
  </td>
  <td style="width:106px;">
    <p align="center">34</p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p>
      <strong>放松度最高值</strong></p>
  </td>
  <td style="width:106px;">
    <p align="center">89</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">93</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">99</p>
  </td>
  <td style="width:106px;">
    <p align="center">92</p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p>
      <strong>放松度最低值</strong></p>
  </td>
  <td style="width:106px;">
    <p align="center">4</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">2</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">14</p>
  </td>
  <td style="width:106px;">
    <p align="center">1</p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p>
      <strong>放松度平均值</strong></p>
  </td>
  <td style="width:106px;">
    <p align="center">51</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">43</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">34</p>
  </td>
  <td style="width:106px;">
    <p align="center">67</p>
  </td>
</tr>
<tr>
  <td colspan="7" style="width:553px;">
    <p align="center">
      <strong>图表</strong></p>
  </td>
</tr>
<tr style='display:none'>
  <td colspan="7" style="width:553px;">
    <p>
      <strong>注：插入脑波的图表，自带标题</strong></p>
  </td>
</tr>
<tr>
  <td colspan="7" style="width:553px;">
    <p align="center" style="margin-left:31.5pt;">
      <strong>意见和建议</strong></p>
  </td>
</tr>
<tr style="display:none">
  <td colspan="7" style="width:553px;">
    <p style="margin-left:31.5pt;">
      <strong>注：根据页面输入填写该部分内容</strong></p>
  </td>
</tr></tbody></table>}

    title_questions=%Q{<p style="margin-left:21.0pt;">
  教学资源实验室评测问卷调查报告（以下为样例，需要参考问卷网站设计问题，以及产生问卷分析的图表）</p>
<p>}
    html_questions=%Q{
<p>
  &nbsp;</p>
  <img height="558" src="file:///C:/Users/scenery/AppData/Local/Temp/msohtmlclip1/01/clip_image002.jpg" width="554" /></p>
<p>
  &nbsp;</p>
}

  title_comprehensive=%Q{<p style="margin-left:21.0pt;">
  教学资源实验室评测总报告</p>}
    html_comprehensive=%Q{<table border="1" cellpadding="0" cellspacing="0">
<tbody><tr>
  <td style="width:130px;">
    <p align="center">
      <strong>测试流程</strong></p>
  </td>
  <td colspan="6" style="width:423px;">
    <p align="center">
      &nbsp;</p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p align="center">
      <strong>测试内容</strong></p>
  </td>
  <td colspan="6" style="width:423px;">
    <p align="center">
      &nbsp;</p>
  </td>
</tr>
<tr>
  <td colspan="7" style="width:553px;">
    <p align="center">
      <strong>测试结果</strong></p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p>
      <strong>测试时间区间</strong></p>
  </td>
  <td colspan="6" style="width:423px;">
    <p align="center">
      &nbsp;</p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p>
      <strong>测试情景</strong></p>
  </td>
  <td colspan="6" style="width:423px;">
    <p align="center">
      &nbsp;</p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p>
      <strong>无线网络总流量</strong></p>
  </td>
  <td colspan="6" style="width:423px;">
    <p align="center">
      &nbsp;</p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p>
      <strong>实验对象抽样</strong></p>
  </td>
  <td style="width:106px;">
    <p align="center">
      <strong>学生1</strong></p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">
      <strong>学生2</strong></p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">
      <strong>学生3</strong></p>
  </td>
  <td style="width:106px;">
    <p align="center">
      <strong>学生4</strong></p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p>
      <strong>教学效果</strong></p>
  </td>
  <td style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p>
      <strong>课堂最高安静指数</strong></p>
  </td>
  <td style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p>
      <strong>课堂最低安静指数</strong></p>
  </td>
  <td style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p>
      <strong>课堂平均安静指数</strong></p>
  </td>
  <td style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p>
      <strong>专注度最高值</strong></p>
  </td>
  <td style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p>
      <strong>专注度最低值</strong></p>
  </td>
  <td style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p>
      <strong>专注度平均值</strong></p>
  </td>
  <td style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p>
      <strong>放松度最高值</strong></p>
  </td>
  <td style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p>
      <strong>放松度最低值</strong></p>
  </td>
  <td style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p>
      <strong>放松度平均值</strong></p>
  </td>
  <td style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
</tr>
<tr>
  <td colspan="7" style="width:553px;">
    <p align="center">
      <strong>图表</strong></p>
  </td>
</tr>
<tr>
  <td colspan="7" style="width:553px;">
    <p>
      <strong>注：插入体态和脑波的图表，自带标题</strong></p>
  </td>
</tr>
<tr>
  <td colspan="7" style="width:553px;">
    <p align="center" style="margin-left:31.5pt;">
      <strong>问卷调查结果</strong></p>
  </td>
</tr>
<tr>
  <td colspan="7" style="width:553px;">
    <p style="margin-left:31.5pt;">
      &nbsp;</p>
  </td>
</tr>
<tr>
  <td colspan="7" style="width:553px;">
    <p align="center" style="margin-left:31.5pt;">
      <strong>意见和建议</strong></p>
  </td>
</tr>
<tr>
  <td colspan="7" style="width:553px;">
    <p style="margin-left:31.5pt;">
      <strong>注：根据页面输入填写该部分内容</strong></p>
  </td>
</tr>
<tr height="0">
  <td>
    &nbsp;</td>
  <td>
    &nbsp;</td>
  <td>
    &nbsp;</td>
  <td>
    &nbsp;</td>
  <td>
    &nbsp;</td>
  <td>
    &nbsp;</td>
  <td>
    &nbsp;</td>
</tr>
</tbody>
</table>
<p>
  &nbsp;</p>
<p>
  &nbsp;</p>
<p style="margin-left:21.0pt;">
  五、电子书包实验室评测问卷调查报告（以下为样例，需要参考问卷网站设计问题，以及产生问卷分析的图表）</p>
<p>
  <img height="558" src="file:///C:/Users/scenery/AppData/Local/Temp/msohtmlclip1/01/clip_image003.jpg" width="554" /></p>
<p>
  &nbsp;</p>
<p>
  &nbsp;</p>
<p style="margin-left:21.0pt;">
  六、电子书包实验室评测报告</p>
<p>
  &nbsp;</p>
<p>
  &nbsp;</p>
<table border="1" cellpadding="0" cellspacing="0">
<tbody>
<tr>
  <td colspan="7" style="width:553px;">
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
    <p align="center">
      &nbsp;</p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p align="center">
      <strong>申请单位</strong></p>
  </td>
  <td colspan="6" style="width:423px;">
    <p align="center">
      &nbsp;</p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p>
      <strong>申请单位联系人</strong></p>
  </td>
  <td colspan="2" style="width:151px;">
    <p>
      &nbsp;</p>
  </td>
  <td colspan="2" style="width:76px;">
    <p>
      <strong>联系方式</strong></p>
  </td>
  <td colspan="2" style="width:196px;">
    <p>
      &nbsp;</p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p align="center">
      <strong>申请时间</strong></p>
  </td>
  <td colspan="2" style="width:151px;">
    <p>
      &nbsp;</p>
  </td>
  <td colspan="2" style="width:76px;">
    <p>
      <strong>版本</strong></p>
  </td>
  <td colspan="2" style="width:196px;">
    <p>
      &nbsp;</p>
  </td>
</tr>
<tr>
  <td colspan="7" style="width:553px;">
    <p align="center">
      <strong>项目背景</strong></p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p align="center">
      <strong>测试目标</strong></p>
  </td>
  <td colspan="6" style="width:423px;">
    <p align="center">
      &nbsp;</p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p align="center">
      <strong>产品名称</strong></p>
  </td>
  <td colspan="6" style="width:423px;">
    <p align="center">
      &nbsp;</p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p align="center">
      <strong>测试地点</strong></p>
  </td>
  <td colspan="6" style="width:423px;">
    <p align="center">
      &nbsp;</p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p align="center">
      <strong>参与人员</strong></p>
  </td>
  <td colspan="6" style="width:423px;">
    <p align="center">
      &nbsp;</p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p align="center">
      <strong>测试流程</strong></p>
  </td>
  <td colspan="6" style="width:423px;">
    <p align="center">
      &nbsp;</p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p align="center">
      <strong>测试内容</strong></p>
  </td>
  <td colspan="6" style="width:423px;">
    <p align="center">
      &nbsp;</p>
  </td>
</tr>
<tr>
  <td colspan="7" style="width:553px;">
    <p align="center">
      <strong>测试结果</strong></p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p>
      <strong>测试时间区间</strong></p>
  </td>
  <td colspan="6" style="width:423px;">
    <p align="center">
      &nbsp;</p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p>
      <strong>测试情景</strong></p>
  </td>
  <td colspan="6" style="width:423px;">
    <p align="center">
      &nbsp;</p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p>
      <strong>无线网络总流量</strong></p>
  </td>
  <td colspan="6" style="width:423px;">
    <p align="center">
      &nbsp;</p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p>
      <strong>实验对象抽样</strong></p>
  </td>
  <td style="width:106px;">
    <p align="center">
      <strong>学生1</strong></p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">
      <strong>学生2</strong></p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">
      <strong>学生3</strong></p>
  </td>
  <td style="width:106px;">
    <p align="center">
      <strong>学生4</strong></p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p>
      <strong>教学效果</strong></p>
  </td>
  <td style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p>
      <strong>课堂最高安静指数</strong></p>
  </td>
  <td style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p>
      <strong>课堂最低安静指数</strong></p>
  </td>
  <td style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p>
      <strong>课堂平均安静指数</strong></p>
  </td>
  <td style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p>
      <strong>专注度最高值</strong></p>
  </td>
  <td style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p>
      <strong>专注度最低值</strong></p>
  </td>
  <td style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p>
      <strong>专注度平均值</strong></p>
  </td>
  <td style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p>
      <strong>放松度最高值</strong></p>
  </td>
  <td style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p>
      <strong>放松度最低值</strong></p>
  </td>
  <td style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
</tr>
<tr>
  <td style="width:130px;">
    <p>
      <strong>放松度平均值</strong></p>
  </td>
  <td style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td colspan="2" style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
  <td style="width:106px;">
    <p align="center">
      &nbsp;</p>
  </td>
</tr>
<tr>
  <td colspan="7" style="width:553px;">
    <p align="center">
      <strong>图表</strong></p>
  </td>
</tr>
<tr>
  <td colspan="7" style="width:553px;">
    <p>
      <strong>注：插入体态和脑波的图表，自带标题</strong></p>
  </td>
</tr>
<tr>
  <td colspan="7" style="width:553px;">
    <p align="center" style="margin-left:31.5pt;">
      <strong>问卷调查结果</strong></p>
  </td>
</tr>
<tr>
  <td colspan="7" style="width:553px;">
    <p style="margin-left:31.5pt;">
      &nbsp;</p>
  </td>
</tr>
<tr>
  <td colspan="7" style="width:553px;">
    <p align="center" style="margin-left:31.5pt;">
      <strong>意见和建议</strong></p>
  </td>
</tr>
<tr>
  <td colspan="7" style="width:553px;">
    <p style="margin-left:31.5pt;">
      <strong>注：根据页面输入填写该部分内容</strong></p>
  </td>
</tr>
<tr height="0">
  <td>
    &nbsp;</td>
  <td>
    &nbsp;</td>
  <td>
    &nbsp;</td>
  <td>
    &nbsp;</td>
  <td>
    &nbsp;</td>
  <td>
    &nbsp;</td>
  <td>
    &nbsp;</td>
</tr>
</tbody>
</table>}
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
        title = 'comprehensive'
        html=html_head + title_comprehensive + html_common_1 + title_behaviours + html_behaviour+ title_mindwave+ html_mindwave + html_foot
    end

  #  return :text=>html
    pdf = WickedPdf.new.pdf_from_string(html)
    save_path = "#{PIC_PATH}/teachResources/reports/report_#{title}_#{id}.pdf"
    File.open(save_path, 'wb') do |file|
      file << pdf
    end
    render :text=>"报告成功生成<br/><a href='/teachResources/reports/report_#{title}_#{id}.pdf'>下载#{title}报告</a><br/><a href='/lab_course'>返回</a>"

=begin

# create a pdf file from a html file without converting it to string
# Path must be absolute path
      pdf = WickedPdf.new.pdf_from_html_file('/your/absolute/path/here')

# create a pdf from string using templates, layouts and content option for header or footer
      WickedPdf.new.pdf_from_string(
          render_to_string('templates/pdf.html.erb', :layout => 'pdfs/layout_pdf'),
          :footer => {
              :content => render_to_string(:layout => 'pdfs/layout_pdf')
          }
      )

# or from your controller, using views & templates and all wicked_pdf options as normal
      pdf = render_to_string :pdf => "some_file_name"

# then save to a file
      save_path = Rails.root.join('pdfs','filename.pdf')
      File.open(save_path, 'wb') do |file|
        file << pdf
      end

      file_name =  "#{PIC_PATH}/teachResources/reports/abc.pdf"
      respond_to do |format|
        format.html
        format.pdf do
          render :pdf => file_name #"file_name"
        end
      end
=end
#    pdf = WickedPdf.new.pdf_from_string('<h1>Hello There!</h1>')
#    #save_path = Rails.root.join('pdfs','filename.pdf')
#   save_path = PIC_PATH.join('teachResources','reports','report_abcd.pdf')
#    File.open(save_path, 'wb') do |file|
#      file << pdf
#    end
#file_name =  "#{PIC_PATH}/teachResources/reports/report_abcd.pdf"
=begin
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => 'report1.pdf',
               :wkhtmltopdf => '/usr/bin/wkhtmltopdf',
              # :template => '/bills/printing.pdf.erb',
               :disposition => "inline",
        :save_to_file => "#{PIC_PATH}/teachResources/reports/report_abcd.pdf"#Rails.root.join('pdf', "rechnung_#{@bills.id}.pdf")
      end
    end
=end
    #render :text=>"<a href='/teachResources/reports/#{save_path[5]}'>#{save_path[5]}</a>"
    # render :text=>"<a href='/teachResources/reports/report_abcd.pdf'>report_abcd.pdf</a>"
=begin
    format.pdf do
      @example_text = "some text"
      render :pdf => "file_name",
             :template => 'layout/show.pdf.erb',
             :layout => 'pdf',
             :footer => {
                 :center => "Center",
                 :left => "Left",
                 :right => "Right"
             }
      end
=end
=begin 没有反应
@reports_id=21
    respond_to do |format|
      format.html
      format.pdf do
        render :pdf => "report_#{@report_id}",
               :wkhtmltopdf => '/usr/bin/wkhtmltopdf',
               :template => '/layouts/show.pdf.erb',
               :disposition => "inline",
              :save_to_file=>"#{PIC_PATH}/teachResources/reports/report_abcd.pdf"
        #:save_to_file => Rails.root.join('pdf', "rechnung_#{@bills.id}.pdf")
      end
    end
=end
    #  pdf = WickedPdf.new.pdf_from_html_file('http://101.226.163.150/lab_reports/1')
    # save_path = Rails.root.join('pdfs','filename.pdf')

  end

  def export_docx


    html =%Q{<html>
<head>
<meta http-equiv=Content-Type content="text/html; charset=gb2312">
<meta name=Generator content="Microsoft Word 15 (filtered)">
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:Wingdings;
	panose-1:5 0 0 0 0 0 0 0 0 0;}
@font-face
	{font-family:宋体;
	panose-1:2 1 6 0 3 1 1 1 1 1;}
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
	{font-family:微软雅黑;
	panose-1:2 11 5 3 2 2 4 2 2 4;}
@font-face
	{font-family:"\@宋体";
	panose-1:2 1 6 0 3 1 1 1 1 1;}
@font-face
	{font-family:"\@微软雅黑";
	panose-1:2 11 5 3 2 2 4 2 2 4;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin:0cm;
	margin-bottom:.0001pt;
	text-align:justify;
	text-justify:inter-ideograph;
	font-size:10.5pt;
	font-family:"Calibri","sans-serif";}
p.MsoHeader, li.MsoHeader, div.MsoHeader
	{mso-style-link:"页眉 Char";
	margin:0cm;
	margin-bottom:.0001pt;
	text-align:center;
	layout-grid-mode:char;
	border:none;
	padding:0cm;
	font-size:9.0pt;
	font-family:"Calibri","sans-serif";}
p.MsoFooter, li.MsoFooter, div.MsoFooter
	{mso-style-link:"页脚 Char";
	margin:0cm;
	margin-bottom:.0001pt;
	layout-grid-mode:char;
	font-size:9.0pt;
	font-family:"Calibri","sans-serif";}
p.MsoListParagraph, li.MsoListParagraph, div.MsoListParagraph
	{margin:0cm;
	margin-bottom:.0001pt;
	text-align:justify;
	text-justify:inter-ideograph;
	text-indent:21.0pt;
	font-size:10.5pt;
	font-family:"Calibri","sans-serif";}
span.Char
	{mso-style-name:"页眉 Char";
	mso-style-link:页眉;}
span.Char0
	{mso-style-name:"页脚 Char";
	mso-style-link:页脚;}
 /* Page Definitions */
 @page WordSection1
	{size:595.3pt 841.9pt;
	margin:72.0pt 90.0pt 72.0pt 90.0pt;
	layout-grid:15.6pt;}
div.WordSection1
	{page:WordSection1;}
 /* List Definitions */
 ol
	{margin-bottom:0cm;}
ul
	{margin-bottom:0cm;}
-->
</style>

</head>

<body lang=ZH-CN style='text-justify-trim:punctuation'>

<div class=WordSection1 style='layout-grid:15.6pt'>

<p class=MsoNormal><span lang=EN-US>&nbsp;</span></p>

<p class=MsoNormal><span lang=EN-US>&nbsp;</span></p>

<p class=MsoNormal style='margin-left:21.0pt;text-indent:-21.0pt'><span
lang=EN-US>一、</span><span style='font-family:宋体'>教学资源实验室体态分析评测报告</span></p>

<table class=MsoNormalTable border=1 cellspacing=0 cellpadding=0
 style='border-collapse:collapse;border:none'>
 <tr>
  <td width=553 colspan=7 valign=top style='width:414.8pt;border:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>基本信息</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>测试项目名称</span></b></p>
  </td>
  <td width=423 colspan=6 valign=top style='width:317.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>申请单位</span></b></p>
  </td>
  <td width=423 colspan=6 valign=top style='width:317.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>申请单位联系人</span></b></p>
  </td>
  <td width=151 colspan=2 valign=top style='width:4.0cm;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span lang=EN-US
  style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=76 colspan=2 valign=top style='width:2.0cm;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>联系方式</span></b></p>
  </td>
  <td width=196 colspan=2 valign=top style='width:147.15pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span lang=EN-US
  style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>申请时间</span></b></p>
  </td>
  <td width=151 colspan=2 valign=top style='width:4.0cm;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span lang=EN-US
  style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=76 colspan=2 valign=top style='width:2.0cm;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>版本</span></b></p>
  </td>
  <td width=196 colspan=2 valign=top style='width:147.15pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span lang=EN-US
  style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=553 colspan=7 valign=top style='width:414.8pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>项目背景</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>测试目标</span></b></p>
  </td>
  <td width=423 colspan=6 valign=top style='width:317.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>课程名称</span></b></p>
  </td>
  <td width=423 colspan=6 valign=top style='width:317.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>测试地点</span></b></p>
  </td>
  <td width=423 colspan=6 valign=top style='width:317.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>参与人员</span></b></p>
  </td>
  <td width=423 colspan=6 valign=top style='width:317.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>测试流程</span></b></p>
  </td>
  <td width=423 colspan=6 valign=top style='width:317.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>测试内容</span></b></p>
  </td>
  <td width=423 colspan=6 valign=top style='width:317.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=553 colspan=7 valign=top style='width:414.8pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>测试结果</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>测试时间区间</span></b></p>
  </td>
  <td width=423 colspan=6 valign=top style='width:317.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>测试情景</span></b></p>
  </td>
  <td width=423 colspan=6 valign=top style='width:317.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>无线网络总流量</span></b></p>
  </td>
  <td width=423 colspan=6 valign=top style='width:317.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>实验对象抽样</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.3pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>学生<span lang=EN-US>1</span></span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>学生<span lang=EN-US>2</span></span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>学生<span lang=EN-US>3</span></span></b></p>
  </td>
  <td width=106 valign=top style='width:79.35pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>学生<span lang=EN-US>4</span></span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>教学效果</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.3pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.35pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>课堂最高安静指数</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.3pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.35pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>课堂最低安静指数</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.3pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.35pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>课堂平均安静指数</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.3pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.35pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=553 colspan=7 valign=top style='width:414.8pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>图表</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=553 colspan=7 valign=top style='width:414.8pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>注：插入体态的图表，自带标题</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=553 colspan=7 valign=top style='width:414.8pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoListParagraph align=center style='margin-left:31.5pt;text-align:
  center;text-indent:0cm;layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>意见和建议</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=553 colspan=7 valign=top style='width:414.8pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoListParagraph style='margin-left:31.5pt;text-indent:0cm;
  layout-grid-mode:char'><b><span style='font-family:"微软雅黑","sans-serif"'>注：根据页面输入填写该部分内容</span></b></p>
  </td>
 </tr>
 <tr height=0>
  <td width=130 style='border:none'></td>
  <td width=106 style='border:none'></td>
  <td width=45 style='border:none'></td>
  <td width=60 style='border:none'></td>
  <td width=15 style='border:none'></td>
  <td width=90 style='border:none'></td>
  <td width=106 style='border:none'></td>
 </tr>
</table>

<p class=MsoNormal><span lang=EN-US>&nbsp;</span></p>

<p class=MsoNormal><span lang=EN-US>&nbsp;</span></p>

<p class=MsoNormal style='margin-left:21.0pt;text-indent:-21.0pt'><span
lang=EN-US>二、</span><span style='font-family:宋体'>教学资源实验室脑波评测报告</span></p>

<p class=MsoNormal><span lang=EN-US>&nbsp;</span></p>

<table class=MsoNormalTable border=1 cellspacing=0 cellpadding=0
 style='border-collapse:collapse;border:none'>
 <tr>
  <td width=553 colspan=7 valign=top style='width:414.8pt;border:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>基本信息</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>测试项目名称</span></b></p>
  </td>
  <td width=423 colspan=6 valign=top style='width:317.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>申请单位</span></b></p>
  </td>
  <td width=423 colspan=6 valign=top style='width:317.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>申请单位联系人</span></b></p>
  </td>
  <td width=151 colspan=2 valign=top style='width:4.0cm;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span lang=EN-US
  style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=76 colspan=2 valign=top style='width:2.0cm;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>联系方式</span></b></p>
  </td>
  <td width=196 colspan=2 valign=top style='width:147.15pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span lang=EN-US
  style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>申请时间</span></b></p>
  </td>
  <td width=151 colspan=2 valign=top style='width:4.0cm;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span lang=EN-US
  style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=76 colspan=2 valign=top style='width:2.0cm;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>版本</span></b></p>
  </td>
  <td width=196 colspan=2 valign=top style='width:147.15pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span lang=EN-US
  style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=553 colspan=7 valign=top style='width:414.8pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>项目背景</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>测试目标</span></b></p>
  </td>
  <td width=423 colspan=6 valign=top style='width:317.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>课程名称</span></b></p>
  </td>
  <td width=423 colspan=6 valign=top style='width:317.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>测试地点</span></b></p>
  </td>
  <td width=423 colspan=6 valign=top style='width:317.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>参与人员</span></b></p>
  </td>
  <td width=423 colspan=6 valign=top style='width:317.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>测试流程</span></b></p>
  </td>
  <td width=423 colspan=6 valign=top style='width:317.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>测试内容</span></b></p>
  </td>
  <td width=423 colspan=6 valign=top style='width:317.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=553 colspan=7 valign=top style='width:414.8pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>测试结果</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>测试时间区间</span></b></p>
  </td>
  <td width=423 colspan=6 valign=top style='width:317.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>测试情景</span></b></p>
  </td>
  <td width=423 colspan=6 valign=top style='width:317.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>无线网络总流量</span></b></p>
  </td>
  <td width=423 colspan=6 valign=top style='width:317.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>实验对象抽样</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.3pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>学生<span lang=EN-US>1</span></span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>学生<span lang=EN-US>2</span></span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>学生<span lang=EN-US>3</span></span></b></p>
  </td>
  <td width=106 valign=top style='width:79.35pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>学生<span lang=EN-US>4</span></span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>教学效果</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.3pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.35pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>专注度最高值</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.3pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.35pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>专注度最低值</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.3pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.35pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>专注度平均值</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.3pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.35pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>放松度最高值</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.3pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.35pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>放松度最低值</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.3pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.35pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>放松度平均值</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.3pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.35pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=553 colspan=7 valign=top style='width:414.8pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>图表</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=553 colspan=7 valign=top style='width:414.8pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>注：插入脑波的图表，自带标题</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=553 colspan=7 valign=top style='width:414.8pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoListParagraph align=center style='margin-left:31.5pt;text-align:
  center;text-indent:0cm;layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>意见和建议</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=553 colspan=7 valign=top style='width:414.8pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoListParagraph style='margin-left:31.5pt;text-indent:0cm;
  layout-grid-mode:char'><b><span style='font-family:"微软雅黑","sans-serif"'>注：根据页面输入填写该部分内容</span></b></p>
  </td>
 </tr>
 <tr height=0>
  <td width=130 style='border:none'></td>
  <td width=106 style='border:none'></td>
  <td width=45 style='border:none'></td>
  <td width=60 style='border:none'></td>
  <td width=15 style='border:none'></td>
  <td width=90 style='border:none'></td>
  <td width=106 style='border:none'></td>
 </tr>
</table>

<p class=MsoNormal><span lang=EN-US>&nbsp;</span></p>

<p class=MsoNormal style='margin-left:21.0pt;text-indent:-21.0pt'><span
lang=EN-US>三、</span><span style='font-family:宋体'>教学资源实验室评测问卷调查报告（以下为样例，需要参考问卷网站设计问题，以及产生问卷分析的图表）</span></p>

<p class=MsoNormal><span lang=EN-US><img width=554 height=558 id="图片 8"
src="报告模版.files/image001.jpg"></span></p>

<p class=MsoNormal><span lang=EN-US>&nbsp;</span></p>

<p class=MsoNormal style='margin-left:21.0pt;text-indent:-21.0pt'><span
lang=EN-US>四、</span><span style='font-family:宋体'>教学资源实验室评测总报告</span></p>

<table class=MsoNormalTable border=1 cellspacing=0 cellpadding=0
 style='border-collapse:collapse;border:none'>
 <tr>
  <td width=553 colspan=7 valign=top style='width:414.8pt;border:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>基本信息</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>测试项目名称</span></b></p>
  </td>
  <td width=423 colspan=6 valign=top style='width:317.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>申请单位</span></b></p>
  </td>
  <td width=423 colspan=6 valign=top style='width:317.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>申请单位联系人</span></b></p>
  </td>
  <td width=151 colspan=2 valign=top style='width:4.0cm;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span lang=EN-US
  style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=76 colspan=2 valign=top style='width:2.0cm;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>联系方式</span></b></p>
  </td>
  <td width=196 colspan=2 valign=top style='width:147.15pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span lang=EN-US
  style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>申请时间</span></b></p>
  </td>
  <td width=151 colspan=2 valign=top style='width:4.0cm;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span lang=EN-US
  style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=76 colspan=2 valign=top style='width:2.0cm;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>版本</span></b></p>
  </td>
  <td width=196 colspan=2 valign=top style='width:147.15pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span lang=EN-US
  style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=553 colspan=7 valign=top style='width:414.8pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>项目背景</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>测试目标</span></b></p>
  </td>
  <td width=423 colspan=6 valign=top style='width:317.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>课程名称</span></b></p>
  </td>
  <td width=423 colspan=6 valign=top style='width:317.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>测试地点</span></b></p>
  </td>
  <td width=423 colspan=6 valign=top style='width:317.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>参与人员</span></b></p>
  </td>
  <td width=423 colspan=6 valign=top style='width:317.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>测试流程</span></b></p>
  </td>
  <td width=423 colspan=6 valign=top style='width:317.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>测试内容</span></b></p>
  </td>
  <td width=423 colspan=6 valign=top style='width:317.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=553 colspan=7 valign=top style='width:414.8pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>测试结果</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>测试时间区间</span></b></p>
  </td>
  <td width=423 colspan=6 valign=top style='width:317.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>测试情景</span></b></p>
  </td>
  <td width=423 colspan=6 valign=top style='width:317.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>无线网络总流量</span></b></p>
  </td>
  <td width=423 colspan=6 valign=top style='width:317.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>实验对象抽样</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.3pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>学生<span lang=EN-US>1</span></span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>学生<span lang=EN-US>2</span></span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>学生<span lang=EN-US>3</span></span></b></p>
  </td>
  <td width=106 valign=top style='width:79.35pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>学生<span lang=EN-US>4</span></span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>教学效果</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.3pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.35pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>课堂最高安静指数</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.3pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.35pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>课堂最低安静指数</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.3pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.35pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>课堂平均安静指数</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.3pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.35pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>专注度最高值</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.3pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.35pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>专注度最低值</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.3pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.35pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>专注度平均值</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.3pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.35pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>放松度最高值</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.3pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.35pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>放松度最低值</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.3pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.35pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>放松度平均值</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.3pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.35pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=553 colspan=7 valign=top style='width:414.8pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>图表</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=553 colspan=7 valign=top style='width:414.8pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>注：插入体态和脑波的图表，自带标题</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=553 colspan=7 valign=top style='width:414.8pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoListParagraph align=center style='margin-left:31.5pt;text-align:
  center;text-indent:0cm;layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>问卷调查结果</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=553 colspan=7 valign=top style='width:414.8pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoListParagraph style='margin-left:31.5pt;text-indent:0cm;
  layout-grid-mode:char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=553 colspan=7 valign=top style='width:414.8pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoListParagraph align=center style='margin-left:31.5pt;text-align:
  center;text-indent:0cm;layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>意见和建议</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=553 colspan=7 valign=top style='width:414.8pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoListParagraph style='margin-left:31.5pt;text-indent:0cm;
  layout-grid-mode:char'><b><span style='font-family:"微软雅黑","sans-serif"'>注：根据页面输入填写该部分内容</span></b></p>
  </td>
 </tr>
 <tr height=0>
  <td width=130 style='border:none'></td>
  <td width=106 style='border:none'></td>
  <td width=45 style='border:none'></td>
  <td width=60 style='border:none'></td>
  <td width=15 style='border:none'></td>
  <td width=90 style='border:none'></td>
  <td width=106 style='border:none'></td>
 </tr>
</table>

<p class=MsoNormal><span lang=EN-US>&nbsp;</span></p>

<p class=MsoNormal><span lang=EN-US>&nbsp;</span></p>

<p class=MsoNormal style='margin-left:21.0pt;text-indent:-21.0pt'><span
lang=EN-US>五、</span><span style='font-family:宋体'>电子书包实验室评测问卷调查报告（以下为样例，需要参考问卷网站设计问题，以及产生问卷分析的图表）</span></p>

<p class=MsoNormal><span lang=EN-US><img width=554 height=558
src="报告模版.files/image002.jpg"></span></p>

<p class=MsoNormal><span lang=EN-US>&nbsp;</span></p>

<p class=MsoNormal><span lang=EN-US>&nbsp;</span></p>

<p class=MsoNormal style='margin-left:21.0pt;text-indent:-21.0pt'><span
lang=EN-US>六、</span><span style='font-family:宋体'>电子书包实验室评测报告</span></p>

<p class=MsoNormal><span lang=EN-US>&nbsp;</span></p>

<p class=MsoNormal><span lang=EN-US>&nbsp;</span></p>

<table class=MsoNormalTable border=1 cellspacing=0 cellpadding=0
 style='border-collapse:collapse;border:none'>
 <tr>
  <td width=553 colspan=7 valign=top style='width:414.8pt;border:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>基本信息</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>测试项目名称</span></b></p>
  </td>
  <td width=423 colspan=6 valign=top style='width:317.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>申请单位</span></b></p>
  </td>
  <td width=423 colspan=6 valign=top style='width:317.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>申请单位联系人</span></b></p>
  </td>
  <td width=151 colspan=2 valign=top style='width:4.0cm;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span lang=EN-US
  style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=76 colspan=2 valign=top style='width:2.0cm;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>联系方式</span></b></p>
  </td>
  <td width=196 colspan=2 valign=top style='width:147.15pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span lang=EN-US
  style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>申请时间</span></b></p>
  </td>
  <td width=151 colspan=2 valign=top style='width:4.0cm;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span lang=EN-US
  style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=76 colspan=2 valign=top style='width:2.0cm;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>版本</span></b></p>
  </td>
  <td width=196 colspan=2 valign=top style='width:147.15pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span lang=EN-US
  style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=553 colspan=7 valign=top style='width:414.8pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>项目背景</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>测试目标</span></b></p>
  </td>
  <td width=423 colspan=6 valign=top style='width:317.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>产品名称</span></b></p>
  </td>
  <td width=423 colspan=6 valign=top style='width:317.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>测试地点</span></b></p>
  </td>
  <td width=423 colspan=6 valign=top style='width:317.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>参与人员</span></b></p>
  </td>
  <td width=423 colspan=6 valign=top style='width:317.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>测试流程</span></b></p>
  </td>
  <td width=423 colspan=6 valign=top style='width:317.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>测试内容</span></b></p>
  </td>
  <td width=423 colspan=6 valign=top style='width:317.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=553 colspan=7 valign=top style='width:414.8pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>测试结果</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>测试时间区间</span></b></p>
  </td>
  <td width=423 colspan=6 valign=top style='width:317.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>测试情景</span></b></p>
  </td>
  <td width=423 colspan=6 valign=top style='width:317.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>无线网络总流量</span></b></p>
  </td>
  <td width=423 colspan=6 valign=top style='width:317.25pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>实验对象抽样</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.3pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>学生<span lang=EN-US>1</span></span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>学生<span lang=EN-US>2</span></span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>学生<span lang=EN-US>3</span></span></b></p>
  </td>
  <td width=106 valign=top style='width:79.35pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>学生<span lang=EN-US>4</span></span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>教学效果</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.3pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.35pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>课堂最高安静指数</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.3pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.35pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>课堂最低安静指数</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.3pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.35pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>课堂平均安静指数</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.3pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.35pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>专注度最高值</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.3pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.35pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>专注度最低值</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.3pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.35pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>专注度平均值</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.3pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.35pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>放松度最高值</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.3pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.35pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>放松度最低值</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.3pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.35pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=130 valign=top style='width:97.55pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>放松度平均值</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.3pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 colspan=2 valign=top style='width:79.3pt;border-top:none;
  border-left:none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
  <td width=106 valign=top style='width:79.35pt;border-top:none;border-left:
  none;border-bottom:solid windowtext 1.0pt;border-right:solid windowtext 1.0pt;
  padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=553 colspan=7 valign=top style='width:414.8pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal align=center style='text-align:center;layout-grid-mode:
  char'><b><span style='font-family:"微软雅黑","sans-serif"'>图表</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=553 colspan=7 valign=top style='width:414.8pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal style='layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>注：插入体态和脑波的图表，自带标题</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=553 colspan=7 valign=top style='width:414.8pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoListParagraph align=center style='margin-left:31.5pt;text-align:
  center;text-indent:0cm;layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>问卷调查结果</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=553 colspan=7 valign=top style='width:414.8pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoListParagraph style='margin-left:31.5pt;text-indent:0cm;
  layout-grid-mode:char'><b><span lang=EN-US style='font-family:"微软雅黑","sans-serif"'>&nbsp;</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=553 colspan=7 valign=top style='width:414.8pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoListParagraph align=center style='margin-left:31.5pt;text-align:
  center;text-indent:0cm;layout-grid-mode:char'><b><span style='font-family:
  "微软雅黑","sans-serif"'>意见和建议</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=553 colspan=7 valign=top style='width:414.8pt;border:solid windowtext 1.0pt;
  border-top:none;padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoListParagraph style='margin-left:31.5pt;text-indent:0cm;
  layout-grid-mode:char'><b><span style='font-family:"微软雅黑","sans-serif"'>注：根据页面输入填写该部分内容</span></b></p>
  </td>
 </tr>
 <tr height=0>
  <td width=130 style='border:none'></td>
  <td width=106 style='border:none'></td>
  <td width=45 style='border:none'></td>
  <td width=60 style='border:none'></td>
  <td width=15 style='border:none'></td>
  <td width=90 style='border:none'></td>
  <td width=106 style='border:none'></td>
 </tr>
</table>

<p class=MsoNormal><span lang=EN-US>&nbsp;</span></p>

</div>

</body>

</html>
}
    html ="<html><head></head><body><table border='1'><tr><td>你好</td><td>图片</td></tr><tr><td><img src='http://101.226.163.150/assets/p_1.png'></td><td></td></tr></table></body></html>"
    html="<html>
<head>
</head>
<body>
<table border='1'>
<tr>
<td>a
</td>
<td>b
</td>
</tr>
<tr>
<td>c
</td>
<td>d
</td>
</tr>
</body>
</html>"
    html=%Q{
    <html>

<head>
<meta http-equiv=Content-Type content="text/html; charset=gb2312">
<meta name=Generator content="Microsoft Word 15 (filtered)">
<style>
<!--
 /* Font Definitions */
 @font-face
	{font-family:Wingdings;
	panose-1:5 0 0 0 0 0 0 0 0 0;}
@font-face
	{font-family:"Cambria Math";
	panose-1:2 4 5 3 5 4 6 3 2 4;}
@font-face
	{font-family:Calibri;
	panose-1:2 15 5 2 2 2 4 3 2 4;}
@font-face
	{font-family:"MS PGothic";
	panose-1:2 11 6 0 7 2 5 8 2 4;}
@font-face
	{font-family:"\@MS PGothic";
	panose-1:2 11 6 0 7 2 5 8 2 4;}
 /* Style Definitions */
 p.MsoNormal, li.MsoNormal, div.MsoNormal
	{margin-top:0cm;
	margin-right:0cm;
	margin-bottom:10.0pt;
	margin-left:0cm;
	line-height:115%;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";}
h1
	{mso-style-link:"标题 1 Char";
	margin-top:24.0pt;
	margin-right:0cm;
	margin-bottom:0cm;
	margin-left:0cm;
	margin-bottom:.0001pt;
	line-height:115%;
	page-break-after:avoid;
	font-size:14.0pt;
	font-family:"Calibri","sans-serif";
	color:#365F91;}
h2
	{mso-style-link:"标题 2 Char";
	margin-top:10.0pt;
	margin-right:0cm;
	margin-bottom:0cm;
	margin-left:0cm;
	margin-bottom:.0001pt;
	line-height:115%;
	page-break-after:avoid;
	font-size:13.0pt;
	font-family:"Calibri","sans-serif";
	color:#4F81BD;}
h3
	{mso-style-link:"标题 3 Char";
	margin-top:10.0pt;
	margin-right:0cm;
	margin-bottom:0cm;
	margin-left:0cm;
	margin-bottom:.0001pt;
	line-height:115%;
	page-break-after:avoid;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";
	color:#4F81BD;}
h4
	{mso-style-link:"标题 4 Char";
	margin-top:10.0pt;
	margin-right:0cm;
	margin-bottom:0cm;
	margin-left:0cm;
	margin-bottom:.0001pt;
	line-height:115%;
	page-break-after:avoid;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";
	color:#4F81BD;
	font-style:italic;}
h5
	{mso-style-link:"标题 5 Char";
	margin-top:10.0pt;
	margin-right:0cm;
	margin-bottom:0cm;
	margin-left:0cm;
	margin-bottom:.0001pt;
	line-height:115%;
	page-break-after:avoid;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";
	color:#243F60;
	font-weight:normal;}
h6
	{mso-style-link:"标题 6 Char";
	margin-top:10.0pt;
	margin-right:0cm;
	margin-bottom:0cm;
	margin-left:0cm;
	margin-bottom:.0001pt;
	line-height:115%;
	page-break-after:avoid;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";
	color:#243F60;
	font-weight:normal;
	font-style:italic;}
p.MsoHeading7, li.MsoHeading7, div.MsoHeading7
	{mso-style-link:"标题 7 Char";
	margin-top:10.0pt;
	margin-right:0cm;
	margin-bottom:0cm;
	margin-left:0cm;
	margin-bottom:.0001pt;
	line-height:115%;
	page-break-after:avoid;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";
	color:#404040;
	font-style:italic;}
p.MsoHeading8, li.MsoHeading8, div.MsoHeading8
	{mso-style-link:"标题 8 Char";
	margin-top:10.0pt;
	margin-right:0cm;
	margin-bottom:0cm;
	margin-left:0cm;
	margin-bottom:.0001pt;
	line-height:115%;
	page-break-after:avoid;
	font-size:10.0pt;
	font-family:"Calibri","sans-serif";
	color:#4F81BD;}
p.MsoHeading9, li.MsoHeading9, div.MsoHeading9
	{mso-style-link:"标题 9 Char";
	margin-top:10.0pt;
	margin-right:0cm;
	margin-bottom:0cm;
	margin-left:0cm;
	margin-bottom:.0001pt;
	line-height:115%;
	page-break-after:avoid;
	font-size:10.0pt;
	font-family:"Calibri","sans-serif";
	color:#404040;
	font-style:italic;}
p.MsoCaption, li.MsoCaption, div.MsoCaption
	{margin-top:0cm;
	margin-right:0cm;
	margin-bottom:10.0pt;
	margin-left:0cm;
	font-size:9.0pt;
	font-family:"Calibri","sans-serif";
	color:#4F81BD;
	font-weight:bold;}
p.MsoTitle, li.MsoTitle, div.MsoTitle
	{mso-style-link:"标题 Char";
	margin-top:0cm;
	margin-right:0cm;
	margin-bottom:15.0pt;
	margin-left:0cm;
	border:none;
	padding:0cm;
	font-size:26.0pt;
	font-family:"Calibri","sans-serif";
	color:#17365D;
	letter-spacing:.25pt;}
p.MsoTitleCxSpFirst, li.MsoTitleCxSpFirst, div.MsoTitleCxSpFirst
	{mso-style-link:"标题 Char";
	margin:0cm;
	margin-bottom:.0001pt;
	border:none;
	padding:0cm;
	font-size:26.0pt;
	font-family:"Calibri","sans-serif";
	color:#17365D;
	letter-spacing:.25pt;}
p.MsoTitleCxSpMiddle, li.MsoTitleCxSpMiddle, div.MsoTitleCxSpMiddle
	{mso-style-link:"标题 Char";
	margin:0cm;
	margin-bottom:.0001pt;
	border:none;
	padding:0cm;
	font-size:26.0pt;
	font-family:"Calibri","sans-serif";
	color:#17365D;
	letter-spacing:.25pt;}
p.MsoTitleCxSpLast, li.MsoTitleCxSpLast, div.MsoTitleCxSpLast
	{mso-style-link:"标题 Char";
	margin-top:0cm;
	margin-right:0cm;
	margin-bottom:15.0pt;
	margin-left:0cm;
	border:none;
	padding:0cm;
	font-size:26.0pt;
	font-family:"Calibri","sans-serif";
	color:#17365D;
	letter-spacing:.25pt;}
p.MsoSubtitle, li.MsoSubtitle, div.MsoSubtitle
	{mso-style-link:"副标题 Char";
	margin-top:0cm;
	margin-right:0cm;
	margin-bottom:10.0pt;
	margin-left:0cm;
	line-height:115%;
	font-size:12.0pt;
	font-family:"Calibri","sans-serif";
	color:#4F81BD;
	letter-spacing:.75pt;
	font-style:italic;}
p.MsoNoSpacing, li.MsoNoSpacing, div.MsoNoSpacing
	{mso-style-link:"无间隔 Char";
	margin:0cm;
	margin-bottom:.0001pt;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";}
p.MsoListParagraph, li.MsoListParagraph, div.MsoListParagraph
	{margin-top:0cm;
	margin-right:0cm;
	margin-bottom:10.0pt;
	margin-left:36.0pt;
	line-height:115%;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";}
p.MsoListParagraphCxSpFirst, li.MsoListParagraphCxSpFirst, div.MsoListParagraphCxSpFirst
	{margin-top:0cm;
	margin-right:0cm;
	margin-bottom:0cm;
	margin-left:36.0pt;
	margin-bottom:.0001pt;
	line-height:115%;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";}
p.MsoListParagraphCxSpMiddle, li.MsoListParagraphCxSpMiddle, div.MsoListParagraphCxSpMiddle
	{margin-top:0cm;
	margin-right:0cm;
	margin-bottom:0cm;
	margin-left:36.0pt;
	margin-bottom:.0001pt;
	line-height:115%;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";}
p.MsoListParagraphCxSpLast, li.MsoListParagraphCxSpLast, div.MsoListParagraphCxSpLast
	{margin-top:0cm;
	margin-right:0cm;
	margin-bottom:10.0pt;
	margin-left:36.0pt;
	line-height:115%;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";}
p.MsoQuote, li.MsoQuote, div.MsoQuote
	{mso-style-link:"引用 Char";
	margin-top:0cm;
	margin-right:0cm;
	margin-bottom:10.0pt;
	margin-left:0cm;
	line-height:115%;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";
	color:black;
	font-style:italic;}
p.MsoIntenseQuote, li.MsoIntenseQuote, div.MsoIntenseQuote
	{mso-style-link:"明显引用 Char";
	margin-top:10.0pt;
	margin-right:46.8pt;
	margin-bottom:14.0pt;
	margin-left:46.8pt;
	line-height:115%;
	border:none;
	padding:0cm;
	font-size:11.0pt;
	font-family:"Calibri","sans-serif";
	color:#4F81BD;
	font-weight:bold;
	font-style:italic;}
span.MsoSubtleEmphasis
	{color:gray;
	font-style:italic;}
span.MsoIntenseEmphasis
	{color:#4F81BD;
	font-weight:bold;
	font-style:italic;}
span.MsoSubtleReference
	{font-variant:small-caps;
	color:#C0504D;
	text-decoration:underline;}
span.MsoIntenseReference
	{font-variant:small-caps;
	color:#C0504D;
	letter-spacing:.25pt;
	font-weight:bold;
	text-decoration:underline;}
span.MsoBookTitle
	{font-variant:small-caps;
	letter-spacing:.25pt;
	font-weight:bold;}
p.MsoTocHeading, li.MsoTocHeading, div.MsoTocHeading
	{margin-top:24.0pt;
	margin-right:0cm;
	margin-bottom:0cm;
	margin-left:0cm;
	margin-bottom:.0001pt;
	line-height:115%;
	page-break-after:avoid;
	font-size:14.0pt;
	font-family:"Calibri","sans-serif";
	color:#365F91;
	font-weight:bold;}
span.Char
	{mso-style-name:"标题 Char";
	mso-style-link:标题;
	font-family:"Calibri","sans-serif";
	color:#17365D;
	letter-spacing:.25pt;}
span.1Char
	{mso-style-name:"标题 1 Char";
	mso-style-link:"标题 1";
	font-family:"Calibri","sans-serif";
	color:#365F91;
	font-weight:bold;}
span.2Char
	{mso-style-name:"标题 2 Char";
	mso-style-link:"标题 2";
	font-family:"Calibri","sans-serif";
	color:#4F81BD;
	font-weight:bold;}
span.3Char
	{mso-style-name:"标题 3 Char";
	mso-style-link:"标题 3";
	font-family:"Calibri","sans-serif";
	color:#4F81BD;
	font-weight:bold;}
span.4Char
	{mso-style-name:"标题 4 Char";
	mso-style-link:"标题 4";
	font-family:"Calibri","sans-serif";
	color:#4F81BD;
	font-weight:bold;
	font-style:italic;}
span.5Char
	{mso-style-name:"标题 5 Char";
	mso-style-link:"标题 5";
	font-family:"Calibri","sans-serif";
	color:#243F60;}
span.6Char
	{mso-style-name:"标题 6 Char";
	mso-style-link:"标题 6";
	font-family:"Calibri","sans-serif";
	color:#243F60;
	font-style:italic;}
span.7Char
	{mso-style-name:"标题 7 Char";
	mso-style-link:"标题 7";
	font-family:"Calibri","sans-serif";
	color:#404040;
	font-style:italic;}
span.8Char
	{mso-style-name:"标题 8 Char";
	mso-style-link:"标题 8";
	font-family:"Calibri","sans-serif";
	color:#4F81BD;}
span.9Char
	{mso-style-name:"标题 9 Char";
	mso-style-link:"标题 9";
	font-family:"Calibri","sans-serif";
	color:#404040;
	font-style:italic;}
span.Char0
	{mso-style-name:"副标题 Char";
	mso-style-link:副标题;
	font-family:"Calibri","sans-serif";
	color:#4F81BD;
	letter-spacing:.75pt;
	font-style:italic;}
span.Char1
	{mso-style-name:"无间隔 Char";
	mso-style-link:无间隔;}
span.Char2
	{mso-style-name:"引用 Char";
	mso-style-link:引用;
	color:black;
	font-style:italic;}
span.Char3
	{mso-style-name:"明显引用 Char";
	mso-style-link:明显引用;
	color:#4F81BD;
	font-weight:bold;
	font-style:italic;}
p.PersonalName, li.PersonalName, div.PersonalName
	{mso-style-name:"Personal Name";
	margin-top:0cm;
	margin-right:0cm;
	margin-bottom:15.0pt;
	margin-left:0cm;
	border:none;
	padding:0cm;
	font-size:14.0pt;
	font-family:"Calibri","sans-serif";
	color:black;
	text-transform:uppercase;
	letter-spacing:.25pt;
	font-weight:bold;}
p.PersonalNameCxSpFirst, li.PersonalNameCxSpFirst, div.PersonalNameCxSpFirst
	{mso-style-name:"Personal NameCxSpFirst";
	margin:0cm;
	margin-bottom:.0001pt;
	border:none;
	padding:0cm;
	font-size:14.0pt;
	font-family:"Calibri","sans-serif";
	color:black;
	text-transform:uppercase;
	letter-spacing:.25pt;
	font-weight:bold;}
p.PersonalNameCxSpMiddle, li.PersonalNameCxSpMiddle, div.PersonalNameCxSpMiddle
	{mso-style-name:"Personal NameCxSpMiddle";
	margin:0cm;
	margin-bottom:.0001pt;
	border:none;
	padding:0cm;
	font-size:14.0pt;
	font-family:"Calibri","sans-serif";
	color:black;
	text-transform:uppercase;
	letter-spacing:.25pt;
	font-weight:bold;}
p.PersonalNameCxSpLast, li.PersonalNameCxSpLast, div.PersonalNameCxSpLast
	{mso-style-name:"Personal NameCxSpLast";
	margin-top:0cm;
	margin-right:0cm;
	margin-bottom:15.0pt;
	margin-left:0cm;
	border:none;
	padding:0cm;
	font-size:14.0pt;
	font-family:"Calibri","sans-serif";
	color:black;
	text-transform:uppercase;
	letter-spacing:.25pt;
	font-weight:bold;}
p.Overview, li.Overview, div.Overview
	{mso-style-name:Overview;
	margin-top:0cm;
	margin-right:0cm;
	margin-bottom:15.0pt;
	margin-left:0cm;
	border:none;
	padding:0cm;
	font-size:16.0pt;
	font-family:"Calibri","sans-serif";
	color:#17365D;
	letter-spacing:.25pt;}
p.OverviewCxSpFirst, li.OverviewCxSpFirst, div.OverviewCxSpFirst
	{mso-style-name:OverviewCxSpFirst;
	margin:0cm;
	margin-bottom:.0001pt;
	border:none;
	padding:0cm;
	font-size:16.0pt;
	font-family:"Calibri","sans-serif";
	color:#17365D;
	letter-spacing:.25pt;}
p.OverviewCxSpMiddle, li.OverviewCxSpMiddle, div.OverviewCxSpMiddle
	{mso-style-name:OverviewCxSpMiddle;
	margin:0cm;
	margin-bottom:.0001pt;
	border:none;
	padding:0cm;
	font-size:16.0pt;
	font-family:"Calibri","sans-serif";
	color:#17365D;
	letter-spacing:.25pt;}
p.OverviewCxSpLast, li.OverviewCxSpLast, div.OverviewCxSpLast
	{mso-style-name:OverviewCxSpLast;
	margin-top:0cm;
	margin-right:0cm;
	margin-bottom:15.0pt;
	margin-left:0cm;
	border:none;
	padding:0cm;
	font-size:16.0pt;
	font-family:"Calibri","sans-serif";
	color:#17365D;
	letter-spacing:.25pt;}
span.question
	{mso-style-name:question;
	font-family:"Calibri","sans-serif";
	font-variant:normal !important;
	text-transform:uppercase;
	font-weight:bold;}
span.h1
	{mso-style-name:h1;
	font-family:"Arial","sans-serif";
	font-weight:bold;}
span.h2
	{mso-style-name:h2;
	font-family:"Arial","sans-serif";
	font-weight:bold;}
span.h3
	{mso-style-name:h3;
	font-family:"Arial","sans-serif";
	font-weight:bold;}
span.h4
	{mso-style-name:h4;
	font-family:"Arial","sans-serif";
	font-weight:bold;}
.MsoChpDefault
	{font-size:11.0pt;
	font-family:"Calibri","sans-serif";}
.MsoPapDefault
	{margin-bottom:10.0pt;
	line-height:115%;}
 /* Page Definitions */
 @page WordSection1
	{size:595.3pt 841.9pt;
	margin:72.0pt 72.0pt 72.0pt 72.0pt;}
div.WordSection1
	{page:WordSection1;}
 /* List Definitions */
 ol
	{margin-bottom:0cm;}
ul
	{margin-bottom:0cm;}
-->
</style>

</head>

<body lang=ZH-CN>

<div class=WordSection1>

<table class=MsoNormalTable border=1 cellspacing=0 cellpadding=0
 style='border-collapse:collapse'>
 <tr>
  <td valign=top style='padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal><span lang=EN-US>a </span></p>
  </td>
  <td valign=top style='padding:0cm 5.4pt 0cm 5.4pt'>
  <span class="h" data-style="green">This text will have a green highlight</span>
  </td>
 </tr>
 <tr>
  <td valign=top style='padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal><span lang=EN-US>c </span></p>
  </td>
  <td valign=top style='padding:0cm 5.4pt 0cm 5.4pt'>
  <p class=MsoNormal><span lang=EN-US>d </span></p>
  </td>
 </tr>
</table>

<p class=MsoNormal><span lang=EN-US>&nbsp;</span></p>

</div>

</body>

</html>

    }
    file_path =  "#{PIC_PATH}/teachResources/reports/"
    #file_path =  "#{PIC_PATH}/reports/report"
    file = Htmltoword::Document.create html, file_path
    #return send_file file
    #@filename ="#{RAILS_ROOT}/tmp/test/test.doc"
   # send_file(@filename, :filename => "test.doc")
    filename=file.path.split('/')
    render :text=>"<a href='/teachResources/reports/#{filename[5]}'>#{filename[5]}</a>"
=begin
    respond_to do |format|
      format.docx do
       # file = Htmltoword::Document.create params[:docx_html_source], "file_name.docx"
        file = Htmltoword::Document.create  my_html, file_name
        send_file file.path, :disposition => "attachment"
      end
    end
=end

    #  send_data package.to_stream.read,:filename=>"report_#{Time.now.strftime('%Y%m%d%H%M%S')}.doc"
  end

  def index
    @lab_reports = LabReport.paginate(:page => params[:page], :per_page => 5).order("created_at DESC")

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @lab_reports }
    end
  end

  # GET /lab_reports/1
  # GET /lab_reports/1.json
  def show
    id = params[:id]
    return render :text=>"<a href='/lab_reports/#{id}/export?title=behaviour'>行为体态分析报告</a></br>
<a href='/lab_reports/#{id}/export?title=mindwave'>脑波分析报告</a></br>
<a href='/lab_reports/#{id}/export?title=questions'>问卷评测报告</a></br>
<a href='/lab_reports/#{id}/export?title=comprehensive'>综合报告</a></br>"
=begin
    @lab_report =  LabReport.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @lab_report }
    end
=end
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
