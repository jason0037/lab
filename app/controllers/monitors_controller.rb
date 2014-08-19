# encoding: utf-8
require 'pp'
require 'rufus-scheduler'

class MonitorsController < ApplicationController
  before_filter :authorize_user!, :receive_data
  # GET /lab_cats
  # GET /lab_cats.json
  layout "blank"#,:except => [:show]

  def receive_data
    # { "router": { "up": 2929, "down": 9092 ,"read_at":"当前时间20140819104034"} }
    if params[:router].blank?
      return  render :text => { :code => 9999}.to_json
    end
    router = params[:router]

    sql ="insert R000001_reading (point_id,read_at,saved_at,value,source) values
          ('000001' ,'#{router[:read_at]}','#{Time.now.strftime('%Y%m%d%H%M%S')}','#{router[:up]}','1')
          ,('000002','#{router[:read_at]}','#{Time.now.strftime('%Y%m%d%H%M%S')}','#{router[:down]}','1')"
    ActiveRecord::Base.connection.execute sql

    render :text => { :code => 0}.to_json
    #  rescue
    #    return render :text=>{ :code => 9999 }.to_json
    #  end
  end

  def get_realtime_data
    equipment_code = params[:equipment_code]
    point_id = params[:point_id]
    source = params[:source]

    table_name = LabEquipmentMapping.get_table_name(equipment_code)
    read_at = Time.now.strftime('%Y%m%d%H%M%S')

    value1 = 0
    value2 = 0
    sql =''

    if point_id.blank?
      point_id='000001'
    end

    case table_name
      when 'M000001'
        if point_id=='000001'
          sql = "select value from #{table_name}_reading where point_id = '000000' and source='#{source}'
          and read_at>= '#{read_at.to_s}'
          order by id desc limit 0,1"
          results = ActiveRecord::Base.connection.execute(sql)

          results.each(:as => :hash) do |row|
             value2= "|#{row["value"]}"
          end
        end
        sql = "select value,read_at from #{table_name}_reading where point_id = '#{point_id}' and source='#{source}'
            and read_at>= '#{read_at.to_s}'
           order by id desc limit 0,1"

      when 'R000001'
        if point_id=='000002'
          sql = "select value from #{table_name}_reading where point_id = '000001' and source='#{source}'
          and read_at>= '#{read_at.to_s}' order by id desc limit 0,1"
          results = ActiveRecord::Base.connection.execute(sql)

          results.each(:as => :hash) do |row|
            value2= "|#{row["value"]}"
          end
        end
        sql = "select value,read_at from #{table_name}_reading where point_id = '#{point_id}' and source='#{source}'
            and read_at>= '#{read_at.to_s}' order by id desc limit 0,1"

      when 'B000001'
        #sql = "select sum(value)/4 as value,read_at from #{table_name}_reading where source=#{source} group by read_at,source order by read_at desc limit 0,1"
        sql = "select value,read_at from #{table_name}_reading where source=#{source} and point_id='000000' order by read_at desc limit 0,1"
      when 'C000001'
     #  read_at = (Time.now-60.seconds).strftime('%Y%m%d%H%M%S')
        sql = "select value,read_at from #{table_name}_reading where point_id = '#{point_id}' and source='#{source}'
          order by id desc limit 0,1"
      else
        sql = "select value,read_at from #{table_name}_reading where point_id = '#{point_id}' and source='#{source}'
        order by id desc limit 0,1"
    end

    results = ActiveRecord::Base.connection.execute(sql)
    results.each(:as => :hash) do |row|
      value1= row["value"]
      read_at = row["read_at"]
    end
    read_at_format = read_at[8..14]
    read_at_format = read_at_format[0..1]+":"+read_at_format[2..3]+":"+read_at_format[4..5]
    render :text=>"&label=#{read_at_format}&value=#{value1}#{value2}"
  end

  def energy_consumption_data
    size = params[:size]
    source =params[:source]
    @source = source
    equipment_code = params[:equipment_code]
    point_id = params[:point_id]

    case point_id
       when '000001'
        caption ="电压（V）"
        max_value="300"
      when '000002'
        caption ="电流（A）"
        max_value="1.50"
      when '000003'
        caption ="功率（kW）"
        max_value="200"
      when '000004'
         caption ="电能（度）"
         max_value="0.5"
      when '000011'
        caption ="设备温度（℃）"
        max_value="100"
      when '000012'
        caption ="湿度（%）"
        max_value="100"
    end

    table_name = LabEquipmentMapping.find_by_equipment_code(equipment_code).table_name
    end_time = Time.now.strftime('%Y%m%d%H%M%S')
    start_time = (Time.now - 5.minutes).strftime('%Y%m%d%H%M%S')

    cats_str = ''
    data_str1 = ''
    data_str2 = ''
    seriesname1=''
    seriesname2=''
    subcaption=''
    xaxisname=''
    showlegend='0'
    showLabels='0'

    if size!='small'
      xaxisname="当前数值"
      showlegend='1'
      showLabels='1'
    end

    sql = "select value,read_at from #{table_name}_reading where point_id = '#{point_id}'
            and read_at >= '#{start_time}' and read_at<='#{end_time}' and source=#{source} order by id"
   # return render :text=>sql
    results = ActiveRecord::Base.connection.execute(sql)

    results.each(:as => :hash) do |row|
      data_str1 += "<set value='#{row["value"]}' />"
      times = row["read_at"][8..14]
      times = times[0..1] + ":"+times[2..3]+":" +times[4..5]

      cats_str += "<category label='#{times}'/>"
    end

    categories = "<categories>#{cats_str}</categories>"
    dataset1 = "<dataset seriesName='#{seriesname1}' showValues='0'>#{data_str1}</dataset>"
    dataset2 =''
#    dataset2 = "<dataset seriesName='#{seriesname2}' showValues='0' parentYAxis='S'>#{data_str2}</dataset>"

    charts="<chart manageresize='1' palette='3' caption='#{caption}' subcaption='#{subcaption}'
datastreamurl='/monitors/get_realtime_data?equipment_code=#{equipment_code}&point_id=#{point_id}&source=#{source}'
canvasbottommargin='10' refreshinterval='6' numbersuffix=''
showlegend='#{showlegend}' showLabels='#{showLabels}'
snumbersuffix='' setadaptiveymin='1' setadaptivesymin='1' xaxisname='#{xaxisname}'
showrealtimevalue='1' labeldisplay='Rotate' slantlabels='1' numdisplaysets='40'
labelstep='1' pyaxisminvalue='0' pyaxismaxvalue='#{max_value}' syaxisminvalue='0' syaxismaxvalue='1' >
#{categories} #{dataset1} #{dataset2}
<styles>
<definition>
<style type='font' name='captionFont' size='14' />
</definition>
<application>
<apply toobject='Caption' styles='captionFont' />
<apply toobject='Realtimevalue' styles='captionFont' />
</application>
</styles>
<trendlines></trendlines>
</chart>"
=begin

    equipment_code = params[:equipment_code]
    size = params[:size]
    table_name = LabEquipmentMapping.find_by_equipment_code(equipment_code).table_name
    #end_time = Time.now.strftime('%Y%m%d%H%M%S')
    #start_time = (Time.now - 5.minutes).strftime('%Y%m%d%H%M%S')
    start_time = "20140424134413"
    end_time =   "20140424161437"

    cats_str = ''
    data_str = ''
    seriesname=''
    pyaxisname=''
    syaxisname=''
    select ="'' as read_at,value/10 as value"

    if size!='small'
      select = "read_at,value/10 as value"
      seriesname='实时能耗'
      pyaxisname="用电量(千瓦时)"
      syaxisname="温度(℃)"
    end
    datas = BData.select("#{select}").where("point_id='000004' and read_at > ? and read_at < ?",start_time,end_time).order("read_at asc")

    datas.each do |data|
      times=data.read_at[8..14]
      if (!times.blank?)
        times =times[0..1]+":"+times[2..3]+":"+times[4..5]

      end
      cats_str += "<category label='#{times}'/>"
      data_str += "<set value='#{data.value}' />"
    end
    categorys = "<categories>#{cats_str}</categories>"
    datasets = "<dataset seriesName='#{seriesname}' showValues='0' parentYAxis='P'>#{data_str}</dataset>"
    charts = "<chart animation='0' manageResize='1' bgColor='00A600,006000'  basefontcolor='FFFFDD' bgAlpha='100'
canvasBorderThickness='1' canvasBorderColor='008040' canvasBgColor='000000'
canvasBgAlpha='100' divLineColor='008040' vDivLineColor='008040' divLineAlpha='100'
caption='能耗监测' dataStreamURL='' refreshInterval='900'
PYAxisName='#{syaxisname}' SYAxisName='#{pyaxisname}' SYAxisMinValue='0' SYAXisMaxValue='40' setAdaptiveYMin='1'
 setAdaptiveSYMin='1'  showRealTimeValue='0' realTimeValuePadding='10' showLabel='0'
labelDisplay='Rotate' slantLabels='1' labelStep='2' numDisplaySets='95' numVDivLines='47'
toolTipBgColor='000000' toolTipBorderColor='008040' baseFontSize='16' baseFont='微软雅黑'
showAlternateHGridColor='0' legendBgColor='000000' legendBorderColor='008040' legendShadow='0'>
<styles><definition><style name='MyFontStyle' type='font' size='24' bold='0'/></definition>
<application><apply toObject='Caption' styles='MyFontStyle' />
</application></styles>#{categorys}#{datasets}</chart>"
=end
    render :text => charts
  end

  def mind_wave_data
    size = params[:size]
    equipment_code = params[:equipment_code]
    point_id = params[:point_id]
    source = params[:source]

    caption =case point_id
      when '000002'
        "delta波"
      when '000003'
        "theta波"
      when '000004'
        "lowAlpha波"
      when '000005'
         "highAlpha波"
      when '000006'
         "lowBeta波"
      when '000007'
        "highBeta波"
      when '000008'
          "lowGamma波"
      when '000009'
          "highGamma波"
      when '00000011'
         "blinkstrength"

      else "实时脑波分析(学生#{source})"

    end

    table_name = LabEquipmentMapping.find_by_equipment_code(equipment_code).table_name
    end_time = Time.now.strftime('%Y%m%d%H%M%S')
    start_time = (Time.now - 5.minutes).strftime('%Y%m%d%H%M%S')

    #datas = BData.where("point_id='#{point_id}' and read_at > ? and read_at < ?",start_time,end_time).order("read_at asc")

    cats_str = ''
    data_str1 = ''
    data_str2 = ''
    seriesname1=''
    seriesname2=''
    subcaption=''
    xaxisname=''
    showlegend='0'
    showLabels='0'

    if size!='small'
      if (point_id == '000000' || point_id.blank?)
        seriesname2="注意力"
        seriesname1="放松度"
        point_id = '000000'
      else
        subcaption="信号功率"
      end

      xaxisname="当前数值"
      showlegend='1'
      showLabels='1'
    end

    if point_id=='000000'
      if !params[:link].blank?
        click_url="clickURL='mind_wave?source=#{source}'"
      else
      # click_url="clickURL='P-detailsPopUp,width=100%,height=450,toolbar=no,scrollbars=no,menubar=0,location=0,status=0
#    ,resizable=no-/monitors/get_big_chart?chart_type=/FusionCharts/RealTimeLineDY.swf&data_source=/monitors/mind_wave_data?equipment_code=002001&point_id=000002&source=#{source}'"
        1
      end
      sql = "select value from #{table_name}_reading where point_id = '#{point_id}'
            and read_at >= '#{start_time}' and read_at<=#{end_time} order by id"
      results = ActiveRecord::Base.connection.execute(sql)

      results.each(:as => :hash) do |row|
        data_str2 += "<set value='#{row["value"]}' />"
      end
      point_id='000001'
    end

    sql = "select value,read_at from #{table_name}_reading where point_id = '#{point_id}'
            and read_at >= '#{start_time}' and read_at<=#{end_time} order by id"
    results = ActiveRecord::Base.connection.execute(sql)

    results.each(:as => :hash) do |row|
      data_str1 += "<set value='#{row["value"]}' />"
      times = row["read_at"][8..14]
      times = times[0..1] + ":"+times[2..3]+":" +times[4..5]

      cats_str += "<category label='#{times}'/>"
    end

    categories = "<categories>#{cats_str}</categories>"
    dataset1 = "<dataset seriesName='#{seriesname1}' showValues='0'>#{data_str1}</dataset>"
    dataset2 = "<dataset seriesName='#{seriesname2}' showValues='0' parentYAxis='S'>#{data_str2}</dataset>"

    charts="<chart  #{click_url} manageresize='1' palette='3' caption='#{caption}' subcaption='#{subcaption}'
datastreamurl='/monitors/get_realtime_data?equipment_code=#{equipment_code}&point_id=#{point_id}&source=#{source}'
canvasbottommargin='10' refreshinterval='1' numbersuffix=''
showlegend='#{showlegend}' showLabels='#{showLabels}'
snumbersuffix='' setadaptiveymin='1' setadaptivesymin='1' xaxisname='#{xaxisname}'
showrealtimevalue='1' labeldisplay='Rotate' slantlabels='1' numdisplaysets='40'
labelstep='1' pyaxisminvalue='0' pyaxismaxvalue='100' syaxisminvalue='0' syaxismaxvalue='100' >
#{categories} #{dataset1} #{dataset2}
<styles>
<definition>
<style type='font' name='captionFont' size='14' />
</definition>
<application>
<apply toobject='Caption' styles='captionFont' />
<apply toobject='Realtimevalue' styles='captionFont' />
</application>
</styles>
<trendlines></trendlines>
</chart>"

    render :text => charts

  end

  def network_data
    size = params[:size]
    equipment_code = params[:equipment_code]
    point_id = params[:point_id]
    source = params[:source]

    caption =case point_id
               when '000003'
                 "theta波"
               when '000004'
                 "lowAlpha波"
               when '000005'
                 "highAlpha波"
               when '000006'
                 "lowBeta波"
               when '000007'
                 "highBeta波"
               when '000008'
                 "lowGamma波"
               when '000009'
                 "highGamma波"
               when '00000011'
                 "blinkstrength"

               else "上下行速率"

             end

    table_name = LabEquipmentMapping.find_by_equipment_code(equipment_code).table_name
    end_time = Time.now.strftime('%Y%m%d%H%M%S')
    start_time = (Time.now - 5.minutes).strftime('%Y%m%d%H%M%S')

    cats_str = ''
    data_str1 = ''
    data_str2 = ''
    seriesname1=''
    seriesname2=''
    subcaption=''
    xaxisname=''
    showlegend='0'
    showLabels='0'

    if size!='small'
      if (point_id == '000001' || point_id.blank?)
        seriesname2="上行速率"
        seriesname1="下行速率"
        point_id = '000001'
      else
        subcaption="总速率"
      end

      xaxisname="当前数值"
      showlegend='1'
      showLabels='1'
    end

    if point_id=='000001'
      sql = "select value from #{table_name}_reading where point_id = '#{point_id}'
            and read_at >= '#{start_time}' and read_at<=#{end_time} order by id"
      results = ActiveRecord::Base.connection.execute(sql)

      results.each(:as => :hash) do |row|
        data_str2 += "<set value='#{row["value"]}' />"
      end
      point_id='000002'
    end

    sql = "select value,read_at from #{table_name}_reading where point_id = '#{point_id}'
            and read_at >= '#{start_time}' and read_at<=#{end_time} order by id"
    results = ActiveRecord::Base.connection.execute(sql)

    results.each(:as => :hash) do |row|
      data_str1 += "<set value='#{row["value"]}' />"
      times = row["read_at"][8..14]
      times = times[0..1] + ":"+times[2..3]+":" +times[4..5]

      cats_str += "<category label='#{times}'/>"
    end

    categories = "<categories>#{cats_str}</categories>"
    dataset1 = "<dataset seriesName='#{seriesname1}' showValues='0'>#{data_str1}</dataset>"
    dataset2 = "<dataset seriesName='#{seriesname2}' showValues='0' parentYAxis='S'>#{data_str2}</dataset>"

    charts="<chart  manageresize='1' palette='3' caption='#{caption}' subcaption='#{subcaption}'
datastreamurl='/monitors/get_realtime_data?equipment_code=#{equipment_code}&point_id=#{point_id}&source=#{source}'
canvasbottommargin='10' refreshinterval='1' numbersuffix=''
showlegend='#{showlegend}' showLabels='#{showLabels}'
snumbersuffix='' setadaptiveymin='1' setadaptivesymin='1' xaxisname='#{xaxisname}'
showrealtimevalue='1' labeldisplay='Rotate' slantlabels='1' numdisplaysets='40'
labelstep='1' pyaxisminvalue='0' pyaxismaxvalue='100' syaxisminvalue='0' syaxismaxvalue='100' >
#{categories} #{dataset1} #{dataset2}
<styles>
<definition>
<style type='font' name='captionFont' size='14' />
</definition>
<application>
<apply toobject='Caption' styles='captionFont' />
<apply toobject='Realtimevalue' styles='captionFont' />
</application>
</styles>
<trendlines></trendlines>
</chart>"

    render :text => charts

=begin
    equipment_code = params[:equipment_code]
    size = params[:size]
    table_name = LabEquipmentMapping.find_by_equipment_code(equipment_code).table_name
    #end_time = Time.now.strftime('%Y%m%d%H%M%S')
    #start_time = (Time.now - 5.minutes).strftime('%Y%m%d%H%M%S')
    start_time = "20140424134413"
    end_time =   "20140424161437"

    cats_str = ''
    data_str = ''
    select =" '' as read_at ,value"
    seriesname=''
    score=''
    pyaxisname=''
    if size!='small'
      select = "read_at,value*10 as value"
      seriesname='实时网络'
      score="学习效果"
      pyaxisname="网速(比特/秒)"
    end
    datas = BData.select("#{select}").where("point_id='000003' and read_at > ? and read_at < ?",start_time,end_time).order("read_at asc")
    datas.each do |data|
      times=data.read_at[8..14]
      if (!times.blank?)
        times =times[0..1]+":"+times[2..3]+":"+times[4..5]

      end
      cats_str += "<category label='#{times}'/>"
      data_str += "<set value='#{data.value}' />"
    end
    categorys = "<categories>#{cats_str}</categories>"
    datasets = "<dataset seriesName='#{seriesname}' showValues='0' parentYAxis='P'>#{data_str}</dataset>"
    charts = "<chart animation='0' manageResize='1' bgColor='009999,333333' basefontcolor='FFFFDD' bgAlpha='100'
canvasBorderThickness='1' canvasBorderColor='008040' canvasBgColor='000000' canvasBgAlpha='100'
divLineColor='008040' vDivLineColor='008040' divLineAlpha='100'
caption='网络监测' dataStreamURL='' refreshInterval='900' PYAxisName='#{pyaxisname}' PYAxisMinValue='0' PYAXisMaxValue='100'
 SYAxisName='#{score}' SYAxisMinValue='0' SYAXisMaxValue='100' setAdaptiveYMin='1' setAdaptiveSYMin='1'
showRealTimeValue='0' realTimeValuePadding='10' showLabel='1' labelDisplay='Rotate' slantLabels='1'
labelStep='2' numDisplaySets='95' numVDivLines='47' toolTipBgColor='000000' toolTipBorderColor='008040'
baseFontSize='16' baseFont='微软雅黑' showAlternateHGridColor='0' legendBgColor='000000'
legendBorderColor='008040' legendShadow='0'><styles><definition><style name='MyFontStyle'
type='font' size='24' bold='0'/></definition><application><apply toObject='Caption' styles='MyFontStyle' />
</application></styles>#{categorys}#{datasets}</chart>"
    render :text => charts
=end
  end

  def behaviour_data_history
    id = params[:id]
    equipment_code = params[:equipment_code]
    size = params[:size]
    table_name = LabEquipmentMapping.find_by_equipment_code(equipment_code).table_name
    start_time = params[:start_at]
    end_time = params[:end_at]

    caption="课堂行为体态分析"
    cats_str = ''
    data_str1 = ''
    seriesname1=''
    subcaption=''
    xaxisname=''
    showlegend='0'
    showLabels='0'

    if size!='small'
      seriesname1="行为体态分析"
      subcaption="动作幅度"
      xaxisname="学生"
      showlegend='1'
      showLabels='1'
      export_str = "exportEnabled='1' exportAtClient='0' exportAction='save' exportFileName='behaviour#{id}' exportCallback='pic_loaded' exportHandler='/fusioncharts/fc_exporter/index'"
    end
    categories = ""
    datasets = ""
    cats_str = ""
    data_str1 = ""
    str = ""
    [1,2,3,4].each do |source|
   # [1].each do |source|
        sql = "select sum(value)/count(*)/80 as value ,left(read_at,12) as read_at from #{table_name}_reading where source=#{source} and point_id='000000' and read_at >= '#{start_time}' and read_at<='#{end_time}' group by left(read_at,12)"
   #     str = str + sql
        results = ActiveRecord::Base.connection.execute(sql)
        data_str1 = ""
        last_time = ""
        results.each(:as => :hash) do |row|
          if last_time == ""
            last_time = row["read_at"]
            times = row["read_at"][8..12]
            #times = times[0..1] + ":"+times[2..3]+":" +times[4..5]
            times = times[0..1] + ":"+times[2..3]
            data_str1 += "<set value='#{row["value"].to_i}' />"
            cats_str += "<category label='#{times}'/>"
          else
            current = DateTime.parse(row["read_at"])
            last = DateTime.parse(last_time)
            dis = (current - last)* 24 * 60
        #    if dis == 20
              last_time = row["read_at"]
              times = row["read_at"][8..12]
              times = times[0..1] + ":"+times[2..3]
              data_str1 += "<set value='#{row["value"].to_i}' />"
              cats_str += "<category label='#{times}'/>"
        #    end
          end
        end

        if categories ==""
          categories = "<categories>#{cats_str}</categories>"
        end
        datasets = datasets + "<dataset seriesName='学生#{source}' showValues='0'>#{data_str1}</dataset>"
    end
    charts="<chart manageresize='1' palette='3' caption='#{caption}' subcaption='#{subcaption}'
canvasbottommargin='10' numbersuffix='' showlegend='#{showlegend}' showLabels='#{showLabels}'
snumbersuffix='' setadaptiveymin='1' setadaptivesymin='1' xaxisname='#{xaxisname}'
showrealtimevalue='1' labeldisplay='Rotate' slantlabels='1' numdisplaysets='40'
labelstep='1' pyaxisminvalue='0' pyaxismaxvalue='100' syaxisminvalue='0' syaxismaxvalue='100' #{export_str}>
#{categories} #{datasets}
<styles>
<definition><style type='font' name='captionFont' size='14' /></definition>
<application>
<apply toobject='Caption' styles='captionFont' />
<apply toobject='Realtimevalue' styles='captionFont' />
</application>
</styles><trendlines></trendlines></chart>"
   render :text => charts
   # render :text => str

  end

  def mindwave_data_history
    id = params[:id]
    equipment_code = params[:equipment_code]
    size = params[:size]
    table_name = LabEquipmentMapping.find_by_equipment_code(equipment_code).table_name
    start_time = params[:start_at]
    end_time = params[:end_at]

    caption="课堂脑波(注意力）分析"
    cats_str = ''
    data_str1 = ''
    seriesname1=''
    subcaption=''
    xaxisname=''
    showlegend='0'
    showLabels='0'

    if size!='small'
      #seriesname1="行为体态分析"
     # subcaption="动作幅度"
     # xaxisname="当前数值"
      showlegend='1'
      showLabels='1'
      export_str = "exportEnabled='1' exportAtClient='0' exportAction='save' exportFileName='mindwave#{id}' exportCallback='pic_loaded' exportHandler='/fusioncharts/fc_exporter/index'"

    end

    categories = ""
    datasets = ""
    cats_str = ""
    data_str1 = ""
    [1,2,3,4].each do |source|
      sql = "select sum(value)/count(*) as value ,left(read_at,12) as read_at from #{table_name}_reading where source=#{source} and point_id='000000' and read_at >= '#{start_time}' and read_at<='#{end_time}' group by left(read_at,12)"

#      sql = "select value,read_at from #{table_name}_reading where source=#{source} and point_id='000000' and read_at >= '#{start_time}' and read_at<='#{end_time}'"
        results = ActiveRecord::Base.connection.execute(sql)
        data_str1 = ""
        results.each(:as => :hash) do |row|
          times = row["read_at"][8..12]
          times = times[0..1] + ":"+times[2..3]
          data_str1 += "<set value='#{row["value"]}' />"
          cats_str += "<category label='#{times}'/>"
        end

        if categories ==""
          categories = "<categories>#{cats_str}</categories>"
        end
        datasets = datasets + "<dataset seriesName='学生#{source}' showValues='0'>#{data_str1}</dataset>"
    end
    charts="<chart manageresize='1' palette='3' caption='#{caption}' subcaption='#{subcaption}'
canvasbottommargin='10' numbersuffix=''
showlegend='#{showlegend}' showLabels='#{showLabels}'
snumbersuffix='' setadaptiveymin='1' setadaptivesymin='1' xaxisname='#{xaxisname}'
showrealtimevalue='1' labeldisplay='Rotate' slantlabels='1' numdisplaysets='40'
labelstep='1' pyaxisminvalue='0' pyaxismaxvalue='100' syaxisminvalue='0' syaxismaxvalue='100' #{export_str}>
#{categories} #{datasets}
<styles>
<definition>
<style type='font' name='captionFont' size='14' />
</definition>
<application>
<apply toobject='Caption' styles='captionFont' />
<apply toobject='Realtimevalue' styles='captionFont' />
</application>
</styles>
<trendlines></trendlines>
</chart>"
    render :text => charts
  end

  def behaviour_data
    equipment_code = params[:equipment_code]
    size = params[:size]
    source = params[:source]
    if source.blank?
      source=1
    end
    table_name = LabEquipmentMapping.find_by_equipment_code(equipment_code).table_name
    end_time = Time.now.strftime('%Y%m%d%H%M%S')
    start_time = (Time.now - 5.minutes).strftime('%Y%m%d%H%M%S')

    caption="实时行为体态(学生#{source})"
    cats_str = ''
    data_str1 = ''
    seriesname1=''
    subcaption=''
    xaxisname=''
    showlegend='0'
    showLabels='0'

    if size!='small'
      seriesname1="行为体态分析"
      subcaption="动作幅度"
      xaxisname="当前数值"
      showlegend='1'
      showLabels='1'
    end

   # sql = "select sum(value)/4 as value,read_at from #{table_name}_reading where source=#{source} and read_at >= '#{start_time}' and read_at<=#{end_time} group by read_at,source"
    sql = "select value,read_at from #{table_name}_reading where source=#{source} and point_id='000000' and read_at >= '#{start_time}' and read_at<=#{end_time}"
    results = ActiveRecord::Base.connection.execute(sql)

    results.each(:as => :hash) do |row|
      data_str1 += "<set value='#{row["value"]}' />"
      times = row["read_at"][8..14]
      times = times[0..1] + ":"+times[2..3]+":" +times[4..5]

      cats_str += "<category label='#{times}'/>"
    end

    categories = "<categories>#{cats_str}</categories>"
    dataset1 = "<dataset seriesName='#{seriesname1}' showValues='0'>#{data_str1}</dataset>"

    charts="<chart manageresize='1' palette='3' caption='#{caption}' subcaption='#{subcaption}'
datastreamurl='/monitors/get_realtime_data?equipment_code=#{equipment_code}&source=#{source}'
canvasbottommargin='10' refreshinterval='1' numbersuffix=''
showlegend='#{showlegend}' showLabels='#{showLabels}'
snumbersuffix='' setadaptiveymin='1' setadaptivesymin='1' xaxisname='#{xaxisname}'
showrealtimevalue='1' labeldisplay='Rotate' slantlabels='1' numdisplaysets='40'
labelstep='1' pyaxisminvalue='0' pyaxismaxvalue='100' syaxisminvalue='0' syaxismaxvalue='100' >
#{categories} #{dataset1}
<styles>
<definition>
<style type='font' name='captionFont' size='14' />
</definition>
<application>
<apply toobject='Caption' styles='captionFont' />
<apply toobject='Realtimevalue' styles='captionFont' />
</application></styles><trendlines></trendlines>
</chart>"
    render :text => charts
  end

  def dashboard_data
    equipment_code = params[:equipment_code][0..2]
    caption=''
    fillcolor=''
    case equipment_code
      when "001"
        caption = "行为体态分析"
        value="0"
        fillcolor = "FF0000,AE0000"
        clickURL='/monitors/behaviour'
      when "002"
        caption = "脑波分析"
        fillcolor = "FF9224,EA7500"
        dail2="<dial id='Dial2' value='0' rearextension='10' basewidth='10' />"
        value=0
        clickURL='/monitors/mind_wave'
      when "003"
        caption = "网络分析"
        fillcolor="009999,333333"
        value="0"
        clickURL='/monitors/network'
      when "004"
        caption = "环境分析"
        fillcolor = "00A600,006000"
        value="0"
        clickURL='/monitors/energy_consumption'
      when "100"
        caption = "实验室综合分析"
        fillcolor ="8F4586,6C3365"
        value="0"
        clickURL='/monitors/lab_comprehensive'
      when "202"
        caption = "交互学习行为"
        fillcolor = "737300,424200"
        value="0"
        clickURL='/monitors/interactive_study'
      when "203"
        caption ="课程学习行为"
        fillcolor = "FF9224,EA7500"
        value="0"
        clickURL='/monitors/course_study'
      when "200"
        caption = "在线课堂综合分析"
        fillcolor ="8F4586,6C3365"
        value="0"
        clickURL='/monitors/online_comprehensive'
    end
    charts="<chart caption='#{caption}' clickURL='#{clickURL}' manageresize='1' origw='350' origh='200' palette='2' bgalpha='0' bgcolor='FFFFFF'
lowerlimit='0' upperlimit='100' numbersuffix='%' showborder='0' basefontcolor='000000' charttopmargin='5'
chartbottommargin='5' tooltipbgcolor='009999' gaugefillmix='{dark-10},{light-70},{dark-10}' gaugefillratio='3'
pivotradius='8' gaugeouterradius='120' gaugeinnerradius='70%' gaugeoriginx='175' gaugeoriginy='170'
trendvaluedistance='5' tickvaluedistance='3' managevalueoverlapping='1' autoaligntickvalues='1' >
<colorrange>
<color minvalue='0' maxvalue='45' code='ceceff' />
<color minvalue='45' maxvalue='80' code='6bbef6' />
<color minvalue='80' maxvalue='100' code='16499a' />
</colorrange>
<dials>
<dial id='Dial1' value='#{value}' rearextension='10' basewidth='10' />
#{dail2}
</dials>

<trendpoints>
<point startvalue='62' displayvalue=' ' usemarker='0' markerradius='8' dashed='1' dashlen='2' dashgap='2' />
</trendpoints>
<annotations>
<annotationgroup id='Grp1' showbelow='1' showshadow='1'>
<annotation type='rectangle' x='$chartStartX+5' y='$chartStartY+5' tox='$chartEndX-5' toy='$chartEndY-5'
radius='10' fillcolor='FFFFFF,FFFFFF' showborder='0' />
</annotationgroup>
</annotations>
<styles><definition>
<style name='RectShadow' type='shadow' strength='3' />
<style name='trendvaluefont' type='font' bold='1' bordercolor='FFFFDD' />
</definition><application>
<apply toobject='Grp1' styles='RectShadow' /><apply toobject='Trendvalues' styles='trendvaluefont' />
</application></styles></chart>"

    render :text => charts
  end

  def comprehensive_data
   equipment_code = params[:equipment_code][0..2]
    size = params[:size]
   showlegend='1'
   category1="<category label='行为体态指数' /><category label='注意力脑波指数' />
<category label='网速' /><category label='学习效果' /><category label='放松度脑波指数' />"
   category2="<category label='潜在辍学者辨识' /><category label='学习者行为模式' />
<category label='个性化推荐' /><category label='课程资源优化' /><category label='管理决策支持' />
<category label='管理决策支持'/><category label='学习平台优化'/><category label='学习成效评估'/>"
   if (size=="small")
     category1="<category label=' ' /><category label=' ' />
<category label=' ' /><category label=' ' /><category label=' ' />"
     category2="<category label=' ' /><category label=' ' />
<category label=' ' /><category label=' ' /><category label=' ' />
<category label=' '/><category label=' '/><category label=' '/>"
     showlegend='0'
   end
    charts1 = "<chart caption='实验课程综合分析' canvasborderalpha='0' radarborderalpha='50' radarborderthickness='1'
radarfillcolor='FFFFFF' showlabels='1' drawanchors='0' ymaxvalue='10' showlimits='0' bgcolor='FFFFFF'
showLegend='#{showlegend}'
legendborderalpha='0' baseFontSize='14' baseFont='微软雅黑'  >
<categories>#{category1}</categories>
<dataset seriesname=' ' color='008ee4' alpha='40'>
<set value='8' /><set value='9' /><set value='9' />
<set value='8' /><set value='7' /><set value='9' /><set value='8' />
</dataset>
<dataset seriesname=' ' color='6baa01' alpha='40'>
<set value='7' /><set value='6' /><set value='6' />
<set value='4' /><set value='7' /><set value='6' /><set value='5' />
</dataset>
</chart>"


charts2="<chart caption='线上课堂综合分析' canvasborderalpha='0' radarborderalpha='50' radarborderthickness='1'
   radarfillcolor='FFFFFF' showlabels='1' drawanchors='0' ymaxvalue='10' showlimits='0' bgcolor='FFFFFF'
legendborderalpha='0' baseFontSize='14' baseFont='微软雅黑'  showLegend='#{showlegend}' >
<categories>#{category2}</categories>
<dataset seriesname=' ' color='008ee4' alpha='40'>
<set value='8' /><set value='9' /><set value='9' /><set value='8' />
<set value='7' /><set value='9' /><set value='8' /><set value='7' />
</dataset>
<dataset seriesname=' ' color='6baa01' alpha='40'>
<set value='7' /><set value='6' /><set value='6' /><set value='4' />
<set value='7' /><set value='6' /><set value='5' /><set value='7' />
</dataset>
</chart>"
   case equipment_code
     when "100"
       charts=charts1
     when "200"
       charts = charts2
   end

    render :text => charts
  end

  def general_behaviour_data

    charts0="<chart clickURL='/monitors/general_behaviour' manageresize='1' decimals='0' numbersuffix='%' placevaluesinside='1' is3d='0'
bordercolor='638400' bgcolor='FFFFFF' usecolornameasvalue='1' caption='一般学习习惯分析'>
<colorrange>
<color minvalue='0' maxvalue='50' name='Normal' code='99CC00' />
<color minvalue='50' maxvalue='75' name='Warning' code='FFFF00' />
<color minvalue='75' maxvalue='100' name='Danger' code='FF0000' />
</colorrange><value>32</value></chart>"

    charts1 = "<chart showtasknames='1' dateformat='dd/mm/yyyy' tooltextbgcolor='FFFFFF' tooltextbordercolor='333333' ganttlinecolor='99CC00' ganttlinealpha='20' basefontcolor='333333' gridbordercolor='99CC00' taskbarroundradius='4' showshadow='0' >
<categories bgcolor='333333' fontcolor='99cc00' isbold='1' fontsize='14'>
<category start='1/9/2013' end='31/12/2013' name='2013' />
<category start='1/1/2014' end='31/7/2014' name='2014' />
</categories>
<categories bgcolor='99cc00' bgalpha='40' fontcolor='333333' align='center' fontsize='10' isbold='1'>
<category start='1/9/2013' end='30/9/2013' name='第1周' />
<category start='1/10/2013' end='31/10/2013' name='第2周' />
<category start='1/11/2013' end='30/11/2013' name='第3周' />
<category start='1/12/2013' end='31/12/2013' name='第4周' />
<category start='1/1/2014' end='31/1/2014' name='第5周' />
<category start='1/2/2014' end='28/2/2014' name='第6周' />
<category start='1/3/2014' end='31/3/2014' name='第7周' />
<category start='1/4/2014' end='30/4/2014' name='第8周' />
<category start='1/5/2014' end='31/5/2014' name='第9周' />
<category start='1/6/2014' end='30/6/2014' name='第10周' />
<category start='1/7/2014' end='31/7/2014' name='第11周' />
</categories>
<processes positioningrid='right' align='center' headertext=' Leader  ' fontcolor='333333' fontsize='11' isbold='1' isanimated='1' bgcolor='99cc00' headerbgcolor='333333' headerfontcolor='99CC00' headerfontsize='16' bgalpha='40'>
<process name='学生1' id='1' />
<process name='学生2' id='2' />
<process name='学生3' id='3' />
<process name='学生4' id='4' />
<process name='学生5' id='5' />
<process name='学生6' id='6' />
</processes>

<tasks width='10'>
<task name='Survey' hovertext='Market Survey' processid='1' start='7/9/2013' end='10/10/2013' id='Srvy' color='99cc00' alpha='60' toppadding='19' />
<task name='Concept' hovertext='Develop Concept for Product' processid='1' start='25/10/2013' end='9/11/2013' id='Cpt1' color='99cc00' alpha='60' />
<task name='Concept' showlabel='0' hovertext='Develop Concept for Product' processid='2' start='25/10/2013' end='9/11/2013' id='Cpt2' color='99cc00' alpha='60' />
<task name='Design' hovertext='Preliminary Design' processid='2' start='12/11/2013' end='25/11/2013' id='Desn' color='99cc00' alpha='60' />
<task name='Product Development' processid='2' start='6/12/2013' end='2/3/2014' id='PD1' color='99cc00' alpha='60' />
<task name='Product Development' processid='3' start='6/12/2013' end='2/3/2014' id='PD2' color='99cc00' alpha='60' />
<task name='Doc Outline' hovertext='Documentation Outline' processid='2' start='6/4/2014' end='1/5/2014' id='DocOut' color='99cc00' alpha='60' />
<task name='Alpha' hovertext='Alpha Release' processid='4' start='15/3/2014' end='2/4/2014' id='alpha' color='99cc00' alpha='60' />
<task name='Beta' hovertext='Beta Release' processid='3' start='10/5/2014' end='2/6/2014' id='Beta' color='99cc00' alpha='60' />
<task name='Doc.' hovertext='Documentation' processid='4' start='12/5/2014' end='29/5/2014' id='Doc' color='99cc00' alpha='60' />
<task name='Website Design' hovertext='Website Design' processid='5' start='18/5/2014' end='22/6/2014' id='Web' color='99cc00' alpha='60' />
<task name='Release' hovertext='Product Release' processid='6' start='5/7/2014' end='29/7/2014' id='Rls' color='99cc00' alpha='60' />
<task name='Dvlp' hovertext='Development on Beta Feedback' processid='3' start='10/6/2014' end='1/7/2014' id='Dvlp' color='99cc00' alpha='60' />
<task name='QA' hovertext='QA Testing' processid='4' start='9/4/2014' end='22/4/2014' id='QA1' color='99cc00' alpha='60' />
<task name='QA2' hovertext='QA Testing-Phase 2' processid='4' start='25/6/2014' end='5/7/2014' id='QA2' color='99cc00' alpha='60' />
</tasks>
<connectors color='99cc00' thickness='2'>
<connector fromtaskid='Cpt1' totaskid='Cpt2' fromtaskconnectstart='1' />
<connector fromtaskid='PD1' totaskid='PD2' fromtaskconnectstart='1' />
<connector fromtaskid='PD1' totaskid='alpha' />
<connector fromtaskid='PD2' totaskid='alpha' />
<connector fromtaskid='DocOut' totaskid='Doc' />
<connector fromtaskid='QA1' totaskid='beta' />
<connector fromtaskid='Dvlp' totaskid='QA2' />
<connector fromtaskid='QA2' totaskid='Rls' />
</connectors>
<milestones>
<milestone date='29/7/2014' taskid='Rls' radius='10' color='333333' shape='Star' numsides='5' borderthickness='1' />
<milestone date='2/3/2014' taskid='PD1' radius='10' color='333333' shape='Star' numsides='5' borderthickness='1' />
<milestone date='2/3/2014' taskid='PD2' radius='10' color='333333' shape='Star' numsides='5' borderthickness='1' />
</milestones>
</chart>"
    point_id = params[:point_id]
    case point_id
      when "000000"
        charts=charts0
      else
        charts= charts1
    end
    render :text => charts
  end

  def interactive_study_data

    charts = "<chart caption='常用的交互方式' numberprefix='人次' plotgradientcolor='' bgcolor='FFFFFF'
showalternatehgridcolor='0' divlinecolor='CCCCCC' showvalues='0' showcanvasborder='0' canvasborderalpha='0'
canvasbordercolor='CCCCCC' canvasborderthickness='1' yaxismaxvalue='30000' captionpadding='30'
yaxisvaluespadding='15' legendshadow='0' legendborderalpha='0'
palettecolors='#f8bd19,#008ee4,#33bdda,#e44a00,#6baa01,#583e78' showplotborder='0' >
<categories>
<category label='Jan' /><category label='Feb' /><category label='Mar' /><category label='Apr' />
<category label='May' /><category label='Jun' /><category label='Jul' /><category label='Aug' />
<category label='Sep' /><category label='Oct' /><category label='Nov' /><category label='Dec' />
</categories>
<dataset seriesname='异步'>
<set value='22400' /><set value='24800' /><set value='21800' /><set value='21800' />
<set value='24600' /><set value='27600' /><set value='26800' /><set value='27700' />
<set value='23700' /><set value='25900' /><set value='26800' /><set value='24800' />
</dataset>
<dataset seriesname='同步'>
<set value='10000' /><set value='11500' /><set value='12500' /><set value='15000' />
<set value='16000' /><set value='17600' /><set value='18800' /><set value='19700' />
<set value='21700' /><set value='21900' /><set value='22900' /><set value='20800' />
</dataset></chart>"
    render :text => charts
  end

  def course_study_data

    charts1 = "<chart manageResize='1' palette='1' lowerLimit='0' upperLimit='300' canvasLeftMargin='120'
canvasRightMargin='40' caption='课程数量' subcaption='1,000s' showBorder='0' showValue='1'>
<colorRange><color minValue='0' maxValue='150'/>
<color minValue='150' maxValue='220'/>
<color minValue='220' maxValue='300'/>
</colorRange><value>260</value>
<target>250</target><styles>
<definition><style name='smallCaption' type='Font' size='11'/>
</definition><application>
<apply toObject='CAPTION' styles='smallCaption'/>
</application></styles></chart>"

charts2="<chart manageResize='1' palette='1' lowerLimit='0' upperLimit='30' canvasLeftMargin='120'
canvasRightMargin='40' caption='课程进度' subcaption='%' numberSuffix='%' showBorder='0' showValue='1'>
<colorRange>
<color minValue='0' maxValue='20'/><color minValue='20' maxValue='25'/>
<color minValue='25' maxValue='30'/>
</colorRange><value>22</value><target>26</target><styles>
<definition><style name='smallCaption' type='Font' size='11'/></definition>
<application><apply toObject='CAPTION' styles='smallCaption'/></application>
</styles></chart>"

charts3="<chart manageResize='1' palette='1' lowerLimit='0' upperLimit='600' canvasLeftMargin='120'
canvasRightMargin='40' caption='平均' subcaption='' showBorder='0' showValue='1'>
<colorRange>
<color minValue='0' maxValue='350'/>
<color minValue='350' maxValue='500'/>
<color minValue='500' maxValue='600'/>
</colorRange>
<value>320</value>
<target>550</target>
<styles>
<definition>
<style name='smallCaption' type='Font' size='11'/>
</definition>
<application>
<apply toObject='CAPTION' styles='smallCaption'/>
</application>
</styles>
</chart>"
    charts4="This XML file does not appear to have any style information associated with it. The document tree is shown below.
<chart manageResize='1' palette='1' lowerLimit='0' upperLimit='2000' canvasLeftMargin='120' canvasRightMargin='40'
caption='课程报名人数' subcaption='Count' showBorder='0' showValue='1'>
<colorRange>
<color minValue='0' maxValue='1200'/>
<color minValue='1200' maxValue='1800'/>
<color minValue='1800' maxValue='2000'/>
</colorRange>
<value>1700</value>
<target>1900</target>
<styles>
<definition>
<style name='smallCaption' type='Font' size='11'/>
</definition>
<application>
<apply toObject='CAPTION' styles='smallCaption'/>
</application>
</styles>
</chart>"
    charts5="This XML file does not appear to have any style information associated with it. The document tree is shown below.
<chart manageResize='1' palette='1' lowerLimit='0' upperLimit='5' canvasLeftMargin='120' canvasRightMargin='40'
caption='作业评分' subcaption='Top Rating of 5' showBorder='0' showValue='1'>
<colorRange>
<color minValue='0' maxValue='3.5'/>
<color minValue='3.5' maxValue='4.5'/>
<color minValue='4.5' maxValue='5'/>
</colorRange>
<value>4.7</value>
<target>4.6</target>
<styles>
<definition>
<style name='smallCaption' type='Font' size='11'/>
</definition>
<application>
<apply toObject='CAPTION' styles='smallCaption'/>
</application>
</styles>
</chart>"
    point_id = params[:point_id]

    charts = case point_id
               when  "000001"
                 charts1
               when  "000002"
                 charts2
               when "000003"
                 charts3
               when "000004"
                 charts4
               when  "000005"
                 charts5
              else charts1
            end

    render :text => charts
  end

  def online

  end

  def general_behaviour

  end

  def interactive_study

  end

  def course_study

  end

  def history
    course_id = params[:lab_course_id]
    @lab_course = LabCourse.find(course_id)
  end

  def index
    course_id = params[:id]
    if course_id.blank?
      @lab_course =LabCourse.where(:status=>1).limit(1).order("created_at DESC")
    else
      @lab_course = LabCourse.find(course_id)
    end

  end

  def comprehensive

  end

  def energy_consumption

  end

  def network

  end

  def mind_wave
    @source = params[:source]
  end

  def behaviour

=begin
#从服务器端采集数据
    scheduler = Rufus::Scheduler.start_new(:thread_name => 'behaviour001')
    @logger ||= Logger.new("log/scheduler.log")
    puts Time.new
    j=0
    scheduler.every  '5s', :timeout => '1m' do
      j= j+1
      read_at = Time.now.strftime('%Y%m%d%H%M%S')
      res = Net::HTTP.get_response(URI.parse('http://180.173.14.8:23456/')).body.split("\r\n")

      res.each do |value|
        sql ="insert B000001_reading (point_id,read_at,saved_at,value,source) values('00000#{value[1,1]}'
          ,'#{read_at}','#{Time.now.strftime('%Y%m%d%H%M%S')}','#{value[2,5]}','#{value[0,1]}')"
        ActiveRecord::Base.connection.execute sql

      end
      if (j>100)
        scheduler.stop
      end
    end
=end
  end

  class BData < LabData
    set_table_name "#{table_name}"
  end

  def get_big_chart
    course_id = params[:id]
    if  course_id.blank?
      @lab_course =LabCourse.where(:status=>1).limit(1).order("created_at DESC")
    else
      @lab_course = LabCourse.find(course_id)
    end
  end
end

