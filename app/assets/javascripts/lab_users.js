$(document).ready(function(){
	// $('#myTab a:last').tab('show');//初始化显示哪个tab 
      
    $('#myTab a').click(function (e) { 
        e.preventDefault();//阻止a链接的跳转行为 
        $(this).tab('show');//显示当前选中的链接及关联的content 
    });
    $(".iframe_btn").click(function(e){
    	var url = $(this).attr("href");
    	$("#tab1_frame").attr("src",url);
    	e.preventDefault();
        e.stopPropagation();
    });
});