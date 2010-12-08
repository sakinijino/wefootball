require 'nokogiri'

def netease_src_uri(year, month, day, type)
  "http://goal.sports.163.com/#{MATCH_TYPE[type]}/schedule/#{year}#{month}#{day}.html"
end

def netease_extract_matches(doc, year, month, day)
  rt = []
  return rt if doc.css("#calender_#{year}#{month}#{day}").length == 0

  rt = doc.css('table.daTb01 tr').map do |tr|
    tds = tr.css('td')
    next if tds.length != 8
    match = {
      :finished => false,
      :host_name => '',
      :guest_name => '',
      :host_goal => nil,
      :guest_goal => nil,
      :start_time => DateTime.new(year.to_i,month.to_i,day.to_i)
    }
    match[:host_name] = tr.css("span.c1 a").first.content
    match[:guest_name] = tr.css("span.c2 a").first.content

    regmat = /(\d{2}):(\d{2})/.match(tds[1].content)
    match[:start_time] = DateTime.new(year.to_i,month.to_i,day.to_i, regmat[1].to_i, regmat[2].to_i) if regmat

    # "\345\256\214\345\234\272" "完场"
    # "\346\234\252\345\274\200\350\265\233" "未开赛"
    match[:finished] = (tds[2].content == "\345\256\214\345\234\272")

    if match[:finished]
      regmat = /(\d*)-(\d*)/.match(tds[4].content)
      if regmat
        match[:host_goal] = regmat[1].to_i
        match[:guest_goal] = regmat[2].to_i
      end
    end
    match
  end

  rt.delete_if {|x| x==nil}
end

alias :src_uri :netease_src_uri
alias :extract_matches :netease_extract_matches


