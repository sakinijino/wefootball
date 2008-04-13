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
        var top_menu = j("#header_menu div.l1_menu")
        var top_menu_items = j("#header_menu div.l1_menu a")
        var l2_menu = j("#header_menu div.l2_menu_list")
        var l2_menu_list = j("#header_menu div.l2_menu_list ul")
        top_menu_items.each(function(i, item){
          item = j(item)
          item.mouseover(function(){
                           top_menu_items.removeClass('selected')
                           item.addClass('selected')
                           top_menu.css('background-image', 'url("/images/top_menu_hover.gif")')
                                   .css('background-position', (item.position().left-20)+'px 0px')

                           l2_menu_list.hide();
                           var l2_ml = j(l2_menu_list[i])
                           l2_ml.show()
                           var left = item.position().left
                           var l2_ml_left = left  - Math.round(l2_ml.outerWidth()/2) + 30
                           l2_ml.css('left', l2_ml_left > 0 ? l2_ml_left : 0);
                           l2_menu.css('background-image', 'url("/images/top_l2_menu_hover.gif")')
                                   .css('background-position', ((left-149>-10) ? ((left-149 < 130) ? (left-149) : 130) : -10)+'px 0px')
                      })
          if (item.hasClass('selected')) item.mouseover();
        })
         
        j(".dropdown_container").each(function(i, item){
            item = j(item)
            var ul = item.find('div.dropdown')
            item.mouseover(function(){ul.show()})
                .mouseout(function(){ul.hide()})
        })
        
        if (j.browser.opera) { // fix opera absolute div in span bug
          var dc = j("#header_setting .dropdown_container")
          if (dc.length > 0) {
            j("#header_setting").css('text-align', 'left')
            dc.css('display', 'block').css('float','left').css('margin-left', '16px').css('text-align', 'center')
          }
        }
        
        j("#header_search .dropdown_container div.dropdown a").click(function(){
            j('#header_search').attr('action', this.href)
            j(this).parent().hide();
            return false;
        })
        
        j("div.fieldWithErrors").each(function (i, item){
             item = j(item)
             item.find("input, textarea, select").focus(function(){item.removeClass('fieldWithErrors').addClass('fieldWithErrorsWhenFocus')})
        })
	
        var dialogs = j("div.jdialog")
        if (dialogs.length > 0) dialogs.dialog({draggable:false, resizable:false, width:"auto", height:"auto"}).dialog('close');
        
        var dialogs = j("div.jmodaldialog")
        if (dialogs.length > 0) dialogs.dialog({
            modal:true, overlay:{opacity:0.7, background:'#fff'},
            draggable:false, resizable:false, width:"auto", height:"auto"}).dialog('close');
         
        j("a.resize_small_icon img").mouseover(function(){
            j(this).css("z-index", "10")
            j(this).animate({marginLeft:"-12px", marginTop:"-12px", width:"48px", height:"48px"}, 300)
        }).mouseout(function(){
            j(this).css("z-index", "0")
            j(this).animate({marginLeft:"0px", marginTop:"0px", width:"22px", height:"22px"})
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
            if (fi=='') province_select.change() //���õ�ʡһ��������ʡ��select
            else if (fi == 'city') city_select.change() //���õ���һ���������е�select
            else { // �������򳡣��������ʡ��
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