// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

var j = jQuery.noConflict();

j(function(){
	j("li.level_1_menu_item").each(function(i, item){
		item = j(item)
		var menu = j(item.find("div.level_2_menu")[0])
		menu.css('display', 'none')
		item.mouseover(function(){menu.css('display', '')})
		item.mouseout(function(){menu.css('display', 'none')})
	})
	
	j("div.jdialog").each(function(i, item){
		item = j(item)
		item.dialog({draggable:false, resizable:false});
		item.dialog('close');
	})
})