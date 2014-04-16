# encoding: utf-8
require 'pp'
class MonitorsController < ApplicationController
  # GET /lab_cats
  # GET /lab_cats.json
  layout "blank"#,:except => [:show]
  
  def camera

  end

  class BData < LabData
   set_table_name "#{table_name}"
  end

  def camera_data
    equipment_code = params[:equipment_code]
    table_name = LabEquipmentMapping.find_by_equipment_code(equipment_code).table_name
    #end_time = Time.now.strftime('%Y%m%d%H%M%S')
    #start_time = (Time.now - 5.minutes).strftime('%Y%m%d%H%M%S')
    start_time = "20100101010001"
    end_time = "20100101010101"
    datas = BData.where("read_at > ? and read_at < ?",start_time,end_time).order("read_at asc")
    
    cats_str = ''
    data_str = ''
    datas.each do |data|
      cats_str += "<category label='#{data.read_at[8..14]}'/>"
      data_str += "<set value='#{data.value}' />"
    end
    categorys = "<categories>#{cats_str}</categories>"
    datasets = "<dataset seriesName='实时能耗' showValues='0' parentYAxis='S'>#{data_str}</dataset>"
    charts = "<chart animation='0' manageResize='1' bgColor='000000' bgAlpha='100'  canvasBorderThickness='1' canvasBorderColor='008040' canvasBgColor='000000' canvasBgAlpha='100' divLineColor='008040' vDivLineColor='008040' divLineAlpha='100' baseFontColor='00dd00' caption='能耗检测/实时趋势图' dataStreamURL='' refreshInterval='900' PYAxisName='用电量(千瓦时)' SYAxisName='温度(℃)' SYAxisMinValue='0' SYAXisMaxValue='40' setAdaptiveYMin='1' setAdaptiveSYMin='1'  showRealTimeValue='0' realTimeValuePadding='10' showLabel='1' labelDisplay='Rotate' slantLabels='1' labelStep='2' numDisplaySets='95' numVDivLines='47' toolTipBgColor='000000' toolTipBorderColor='008040' baseFontSize='16' baseFont='微软雅黑' showAlternateHGridColor='0' legendBgColor='000000' legendBorderColor='008040' legendShadow='0'><styles><definition><style name='MyFontStyle' type='font' size='24' bold='0'/></definition><application><apply toObject='Caption' styles='MyFontStyle' /></application></styles>#{categorys}#{datasets}</chart>"
    render :text => charts
  end
end
