//= require jquery.ui.datepicker
//= require jquery-ui-timepicker-addon

$(document).ready(function(){
    $(".datetime").datetimepicker({
        dateFormat: "yy-mm-dd",
        timeFormat: "hh:mm:ss",
        showSecond: true
    });
});