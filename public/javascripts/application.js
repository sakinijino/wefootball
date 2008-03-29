// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

if (!window['j']) j = jQuery.noConflict();
if (!window['wefootball']) wefootball = {}

wefootball.checkAllInputs = function (value){
    if (value == null) value = true;
    j("input[type='checkbox']").attr('checked', value)
}

wefootball.openDialog = function (event, id){
    var item = j(id)
    T = event
    item.dialog("open", {top:event.clientY, left:event.clientX});
}

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
		item.dialog({draggable:false, resizable:false, width:"auto", height:"auto"});
		item.dialog('close');
	})
         
        j("div.tab_container").each(function(i, container){
            var index = 0;
            var links = j(container).find(".tab_link")
            var divs = j(container).find(".tab")
            links.each(function(i, link){
                if (divs[i]!=null) {
                    if (j(link).hasClass('tabSelected')) index = i;
                    j(link).click(function(){
                        links.removeClass('tabSelected')
                        j(link).addClass('tabSelected')
                        divs.hide()
                        if (divs[i]!=null) j(divs[i]).show();
                        return false;
                    })
                }
            })
            divs.hide()
            if (links[index]!=null) j(links[index]).click()
        })
        
        j("span.province_city_select").each(function(i, span){
            var selects = j(span).find("select")
            var province_select = j(selects[0])
            var city_select = j(selects[1])
            province_select.attr('id', '')
            province_select.attr('name', '')
            province_select.change(function(e){
                city_select.get()[0].options.length = 0;
                city_select.get()[0].options[city_select.get()[0].options.length] = new Option(
                        '------', e.target.value
                    )
                j.each(ProvinceCity_TOP_LIST[e.target.value], function(i, city_id){
                    city_select.get()[0].options[city_select.get()[0].options.length] = new Option(
                        ProvinceCity_LIST[city_id], city_id
                    )
                })
                if (e.target.value == 0) city_select.hide()
                else city_select.show()
            })
            var tmp = span.id.split('-')
            if (tmp.length < 5 || tmp[4] == '') return
            var si = tmp[4]
            province_select.get()[0].value = ProvinceCity_REVERSE_LIST[si]
            province_select.change()
            city_select.get()[0].value = si;
        })
        
        j("span.football_ground_select").each(function(i, span){
            var selects = j(span).find("select")
            var province_select = j(selects[0])
            var city_select = j(selects[1])
            var football_ground_select = j(selects[2])
            city_select.attr('id', '')
            city_select.attr('name', '')
            province_select.change(function(e){
                if (e.target.value == 0) {
                    football_ground_select.get()[0].options.length = 0;
                    football_ground_select.get()[0].options[0] = new Option('------', '')
                }
            })
            city_select.change(function(e){
                football_ground_select.get()[0].options.length = 0;
                football_ground_select.get()[0].options[0] = new Option('------', '')
                if (City_FootballGround_LIST[e.target.value] == null) return;
                j.each(City_FootballGround_LIST[e.target.value], function(i, fg_id){
                    football_ground_select.get()[0].options[football_ground_select.get()[0].options.length] = 
                        new Option(FootballGround_LIST[fg_id], fg_id)
                })
            })
            var fi = span.id.split('-')[4]
            if (fi=='') province_select.change()
            else if (fi == 'city') city_select.change()
            else {
                province_select.get()[0].value = ProvinceCity_REVERSE_LIST[FootballGround_REVERSE_LIST[fi]]
                province_select.change()
                city_select.get()[0].value = FootballGround_REVERSE_LIST[fi];
                city_select.change()
                football_ground_select.get()[0].value = fi;
            }
        })
        
        j('div.location_input').each(function(i, div){
            var div = j(div)
            var fgi = j(div.find(".football_ground_input")[0])
            var lti = j(div.find(".location_text_input")[0])
            var selects = div.find("span.football_ground_select select")
            var province_select = j(selects[0])
            var city_select = j(selects[1])
            var football_ground_select = j(selects[2])
            province_select.change(function(e){lti.show()})
            city_select.change(function(e){lti.show()})
            football_ground_select.change(function(e){
                if (e.target.value == '') lti.show()
                else lti.hide()
            })
            football_ground_select.change()
        })
})