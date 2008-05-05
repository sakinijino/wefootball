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
          item.mouseover(function(){ T=item
                           top_menu_items.removeClass('selected')
                           item.addClass('selected')
                           top_menu.css('background-image', 'url("/images/top_menu_hover.gif")')
                                   .css('background-position', (item.position().left-(35-Math.round(item.outerWidth()/2)))+'px 0px')

                           l2_menu_list.hide();
                           var l2_ml = j(l2_menu_list[i])
                           l2_ml.show()
                           var left = item.position().left
                           var l2_ml_width = l2_ml.outerWidth()
                           var l2_ml_left = left  - Math.round(l2_ml_width/2) + 30
                           var l2_ml_right = left + Math.round(l2_ml_width/2) + 30
                           l2_ml.css('left', l2_ml_left > 0 ? (l2_ml_right > 497 ? (497-l2_ml_width) : l2_ml_left) : 0);
                           l2_menu.css('background-image', 'url("/images/top_l2_menu_hover.gif")')
                                   .css('background-position', ((left-149>-10) ? ((left-149 < 130) ? (left-149) : 130) : -10)+'px 0px')
                      })
          if (item.hasClass('selected')) item.mouseover();
        })
         
        j(".dropdown_container").each(function(i, item){
            item = j(item)
            var ul = item.find('div.dropdown')
            item.hover(function(){ul.show()}, function(){ul.hide()})
        })
        
        if (j.browser.opera) { // fix opera absolute div in span bug
          var dc = j("#header_setting .dropdown_container")
          if (dc.length > 0) {
            j("#header_setting").css('text-align', 'left')
            dc.css('display', 'block').css('float','left').css('margin-left', '16px').css('text-align', 'center')
          }
        }
        
        j("#header_search .dropdown_container div.dropdown div").click(function(){
            var item = j(this)
            j("#header_search .dropdown_container img:first").attr('src', item.find('img').attr('src'))
            j("#header_search .dropdown_container img:first").attr('title', item.find('img').attr('title'))
            
            j("#header_search input.input").attr('default_value', item.find('img').attr('title'))
            j("#header_search input.blurinput").attr('value', item.find('img').attr('title'))
            
            j('#header_search').attr('action', item.find('a')[0].href)
            item.parent().hide();
            return false;
        })
        
        j("#header_search input.blurinput").one('focus' ,function(){
            this.value = ''
            j(this).removeClass('blurinput')
        })
        
        if (j.browser.msie && j.browser.version != '7.0')
          j("#header_search .dropdown_container div.dropdown div").hover(
            function(){j(this).addClass('hover')}, 
            function(){j(this).removeClass('hover')}
          )
        
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
         
        j("a.resize_small_icon img").hover(
          function(){
            j(this).css("z-index", "10")
            j(this).animate({marginLeft:"-12px", marginTop:"-12px", width:"48px", height:"48px"}, 300)
          }, 
          function(){
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
        
        j("#user_is_playable").change(function(){
          if (this.checked) {
            j('#playable_info input').attr('disabled', false)
            j('#playable_info select').attr('disabled', false)
          }  
          else {
            this.checked = !confirm('真的不踢球了吗? 确定后你会被从所有队伍的阵型中去掉。')
            if (!this.checked) {
              j('#playable_info input').attr('disabled', true)
              j('#playable_info select').attr('disabled', true)
            }
          }
        })
        if (j.browser.msie) j("#user_is_playable").click(function(){this.blur()})
        if (!j("#user_is_playable").attr('checked')){
          j('#playable_info input').attr('disabled', true)
          j('#playable_info select').attr('disabled', true)
        }
        
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
                else {
                  city_select.show()
                  city_select.change();
                }
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
            var football_ground_select = selects[2]
            var location_input = lti.find('input')[0]
            fgi.find("a.switch").click(function(){
              football_ground_select.value = ''
              fgi.slideUp();
              lti.slideDown();
            })
            lti.find("a.switch").click(function(){
              lti.slideUp();
              fgi.slideDown();
            })
            if (football_ground_select.value != '') {
              location_input.value = ''
              lti.hide();
            }
            else if (location_input.value == '') lti.hide();
            else fgi.hide();
        })
        
        j('div.result_input').each(function(i, div){
          var div = j(div)
          var gi = j(div.find(".goal_input")[0])
          var si = j(div.find(".situation_input")[0])
          
          div.find("a.fill_result").click(function(){
            var results = this.id.split('-')
            if (results[0] == 'goal') {
              var goals = results
              if (goals[1]!='') gi.find('input')[0].value = goals[1]
              if (goals[2]!='') gi.find('input')[1].value = goals[2]
              var sw = div.find("input.goal_input_switch")
              sw.attr('checked', 'checked')
              sw.change()
            }
            else if (results[0] == 'situation') {
              var situs = results
              if (situs[1]=='1') {
                var sw = div.find("input.donotcare_input_switch")
                sw.attr('checked', 'checked')
                sw.change()
              }
              else if (situs[1]!='') {
                si.find('input[@value='+situs[1]+']').attr('checked', 'checked')
                var sw = div.find("input.situation_input_switch")
                sw.attr('checked', 'checked')
                sw.change()
              }
            }
          })
          
          div.find("input.situation_input_switch").change(function(){
            if (this.checked) {
              gi.slideUp();
              si.slideDown();
            }
          })
          div.find("input.goal_input_switch").change(function(){
            if (this.checked) {
              si.slideUp();
              gi.slideDown();
            }
          })
          div.find("input.donotcare_input_switch").change(function(){
            if (this.checked) {
              si.slideUp();
              gi.slideUp();
            }
          })
          if (j.browser.msie) {
            div.find("input.situation_input_switch").click(function(){this.blur()})
            div.find("input.goal_input_switch").click(function(){this.blur()})
            div.find("input.donotcare_input_switch").click(function(){this.blur()})
          }
          div.find("input.switch[@checked]").change();
        })
})