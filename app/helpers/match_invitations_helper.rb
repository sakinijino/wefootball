module MatchInvitationsHelper
   MATCH_TYPE_TEXTS = {1=>'随便玩玩', 2=>'真刀真枪'}
   WIN_RULE_TEXTS = {1=>'直接结束', 2=>'加时点球', 3=> '直接点球'}
     
  def match_type_text(label)
   MatchInvitationsHelper::MATCH_TYPE_TEXTS[label]
  end
  
  def win_rule_text(label)
   MatchInvitationsHelper::WIN_RULE_TEXTS[label]
  end
  
  def macth_invitation_comparison_tr(mi, title, property)
    is_modified = mi.has_attribute_been_modified?(property)
    cssklass = "class=\"conflict\""
    %(<tr>
        <td style="width:60px">#{title}</td>
        <td #{cssklass if is_modified}>#{yield mi[('new_' + property.to_s).to_sym]}</td>
        <td #{cssklass if is_modified}>#{mi[property].nil? ? '无' : is_modified ? yield(mi[property]) : '一致'}</td>  
      </tr>)
  end
  
  def macth_invitation_comparison_form_tr(mi, title, property, block_display, block_edit)
    is_modified = mi.has_attribute_been_modified?(property)
    cssklass = "class=\"conflict\""
    %(<tr>
        <td style="width:60px">#{title}</td>
        <td style="width:280px" >#{block_edit.call}</td>
        <td #{cssklass if is_modified}>#{block_display.call(mi[('new_' + property.to_s).to_sym])}</td>
        <td #{cssklass if is_modified}>#{mi[property].nil? ? '无' : is_modified ? block_display.call(mi[property]) : '一致'}</td>  
      </tr>)
  end
end
