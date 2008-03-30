if (!window['j']) j = jQuery.noConflict();
if (!window['wefootball']) wefootball = {}

wefootball.formation = function(max_size, field, submit_url){
    this.max_size = max_size;
    this.submit_url = submit_url
    this.current_size = 0
    this.field = field;
    this.positions = {
        0:null, 
        1:null, 2:null, 3:null, 4:null, 5:null,
        6:null, 7:null, 8:null, 9:null, 10:null,
        11:null, 12:null, 13:null, 14:null, 15:null,
        16:null, 17:null, 18:null, 19:null, 20:null,
        21:null, 22:null, 23:null, 24:null, 25:null
    }
    this.position_elems = {}
    this.j_position_elems = {}
    this.initField();
}

wefootball.formation.topPosMap = {0:520-35, 1: 520-90, 2: 520-180, 3:520-257, 4:520-347, 5:520-445}
wefootball.formation.leftPosMap = {1:186-135, 2: 186-65, 3: 186, 4:186+65, 0:186+135}
wefootball.formation.getPositionPos = function(i) {
    var top = wefootball.formation.topPosMap[Math.ceil(i/5)]
    var left = Math.ceil(i/5)==0 ? wefootball.formation.leftPosMap[3] : wefootball.formation.leftPosMap[i%5]
    return {top:top, left:left}
}

wefootball.formation.prototype = {
    initField : function(){
        var _this = this
        j.each(this.positions, function(pos){
            _this.position_elems[pos] = j("<div class='pos_elem'></div>")
            _this.field.append(_this.position_elems[pos])
            _this.position_elems[pos]
                .css('top', wefootball.formation.getPositionPos(pos).top - 20)
                .css('left', wefootball.formation.getPositionPos(pos).left - 20)
                .css('opacity', 0.5)
                .droppable({
                    accept: "*",
                    activeClass: "accept_elem",
                    hoverClass: "over_accept_elem",
                    activate: function(){
                        //_this.adjustPositions(true)
                    },
                    deactivate: function(e, ui){
                        ui.helper[0].player.tiny_img.mouseout()
                    },
                    drop: function(e, ui) {
                        _this.setPlayerToPosition(pos, ui.helper[0].player)
                        _this.adjustPositions()
                    }
                });
        })
        this.j_position_elems = this.field.find("div.pos_elem")
    },
    setPlayerToPosition: function(pos, player){
        if (this.positions[pos]!=null) { //将待选位置清空
            this.positions[pos].setPosition(null)
            this.positions[pos] = null
            if (this.current_size > 0) this.current_size--
        }
        if (player!=null) { //将队员从现在位置上去除
            var _this = this
            for (var tmp_pos in this.positions) {
                if (this.positions[tmp_pos]!=null && this.positions[tmp_pos].user_id == player.user_id) {
                    player.setPosition(null)
                    this.positions[tmp_pos] = null;
                    if (this.current_size > 0) this.current_size--
                }
            }
        }
        if (this.current_size < this.max_size && player!=null && pos!=null) { //将队员放入位置
            player.setPosition(pos)
            this.positions[pos] = player;
            this.current_size++
        }
    },
    adjustPositions: function(revert){
        var offset = revert ? 0 : 15
        var f = function (center_pos){
            if (this.positions[center_pos]==null && this.positions[center_pos-1]!=null)
                this.positions[center_pos-1].tiny_img.css('left', wefootball.formation.getPositionPos(center_pos-1).left - 18 + offset)
            if (this.positions[center_pos]==null && this.positions[center_pos+1]!=null)
                this.positions[center_pos+1].tiny_img.css('left', wefootball.formation.getPositionPos(center_pos+1).left - 18 - offset)
        }
        f.call(this, 3)
        f.call(this, 8)
        f.call(this, 13)
        f.call(this, 18)
        f.call(this, 23)
    },
    addPlayer : function(player) {
        this.field.append(player.tiny_img)
        var _this = this
        player.tiny_img.find('div.del').click(function(){
            _this.setPlayerToPosition(null, player)
        })
        player.field = this;
    },
    submit: function() {
        var f = document.createElement('form');
        f.style.display = 'none';
        j('body').append(f);
        f.method = 'POST';
        f.action = this.submit_url;
        var m = document.createElement('input');
        m.setAttribute('type', 'hidden');
        m.setAttribute('name', '_method');
        m.setAttribute('value', 'put');
        f.appendChild(m);
        for (var pos in this.positions) {
            var player = this.positions[pos]
            if (player == null) continue;
            var m = document.createElement('input');
            m.setAttribute('type', 'hidden');
            m.setAttribute('name', 'formation['+pos+']');
            m.setAttribute('value', player.ut_id);
            f.appendChild(m);
        }
        f.submit();
    }
}

wefootball.player = function(options){
    j.extend(this, options)
    this.helper = j(this.tiny_image_tag)
    this.helper[0].player = this;
    var _this = this
    var drag_options = {
        helper: function(){return _this.helper},
        cursorAt: {left:20, top:20},
        start: function(){_this.field.adjustPositions(true)},
        stop: function(){_this.field.adjustPositions()}
    }
    this.small_img = j("<div><div class='del'>X</div>"+this.small_image_tag+"<span>"+this.nickname+"</span>"+"</div>")
        .addClass('icon')
    this.tiny_img = j("<div style='width:40px;height:40px'>"+this.tiny_image_tag+"</div>")
        .append(this.small_img)
        .mouseover(function(){
            _this.small_img.css('display', 'block')
                .css('top', -10)
                .css('left', -17)
        })
        .mouseout(function(){
            _this.small_img.css('display', 'none')
                .css('top', 0)
                .css('left', 0)
        })
        .css('display', 'none')
        .css('position', 'absolute')
        .draggable(drag_options);
    this.handles = j(".user_"+this.user_id)
        .draggable(drag_options);  
    if (j.browser.msie) this.fixSuperDrag(); //fix maxthon image-super-drag 
}

wefootball.player.prototype = {
    setPosition : function(pos) {
        this.position = pos;
        if (pos!=null) {
            this.tiny_img.css('display', 'block')
                .css('top', wefootball.formation.getPositionPos(pos).top - 17)
                .css('left', wefootball.formation.getPositionPos(pos).left - 18)
            this.handles.addClass("selected_player")
        } else {
            this.tiny_img.css('display', 'none')
                .css('top', 0)
                .css('left', 0)
            this.handles.removeClass("selected_player")
        }
    },
    fixSuperDrag : function() {
        var cover_div = "<div style='width:56px;height:56px;background:#fff;position:absolute;top:5px;left:8px'></div>"
        this.handles.css('position', 'relative')
            .append(j(cover_div).css('opacity', 0))
        this.small_img.append(j(cover_div).css('opacity', 0))
    }
}