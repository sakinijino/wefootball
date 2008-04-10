# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def word_wrap_with_wbr(str, interval = 5)
    section = str.chars.length / interval + ((str.chars.length % interval) == 0 ? 0 : 1)
    tmp = []
    (0...section).each do |i|
      tmp[i] = str.chars.slice(interval*i, interval)
    end
    return tmp.join('<wbr/>')
  end
  
  def distance_of_time_in_words(from_time, to_time = 0, include_seconds = false)
    from_time = from_time.to_time if from_time.respond_to?(:to_time)
    to_time = to_time.to_time if to_time.respond_to?(:to_time)
    distance_in_minutes = (((to_time - from_time).abs)/60).round
    distance_in_seconds = ((to_time - from_time).abs).round
    
    case distance_in_minutes
    when 0..1
      return (distance_in_minutes == 0) ? 
        '不到1分钟' : #'less than a minute' : 
        '1分钟' unless include_seconds #'1 minute' unless include_seconds
      case distance_in_seconds
      when 0..4   then '不到5秒'#'less than 5 seconds'
      when 5..9   then '不到10秒'#'less than 10 seconds'
      when 10..19 then '不到20秒'#'less than 20 seconds'
      when 20..39 then '不到半分钟'#'half a minute'
      when 40..59 then '不到1分钟'#'less than a minute'
      else             '1分钟'#'1 minute'
      end
      
    when 2..44           then "#{distance_in_minutes}分钟"#"#{distance_in_minutes} minutes"
    when 45..89          then '1小时左右'#'about 1 hour'
    when 90..1439        then '#{(distance_in_minutes.to_f / 60.0).round}小时左右'#"about #{(distance_in_minutes.to_f / 60.0).round} hours"
    when 1440..2879      then '1天'#'1 day'
    when 2880..43199     then "#{(distance_in_minutes / 1440).round}天"#"#{(distance_in_minutes / 1440).round} days"
    when 43200..86399    then '1个月左右'#'about 1 month'
    when 86400..525599   then "#{(distance_in_minutes / 43200).round}月"#"#{(distance_in_minutes / 43200).round} months"
    when 525600..1051199 then "1年左右"#'about 1 year'
    else                      "#{(distance_in_minutes / 525600).round}年"#"over #{(distance_in_minutes / 525600).round} years"
    end
  end
  
  def error_messages_for(*params)
    options = params.extract_options!.symbolize_keys
    if object = options.delete(:object)
      objects = [object].flatten
    else
      objects = params.collect {|object_name| instance_variable_get("@#{object_name}") }.compact
    end
    count   = objects.inject(0) {|sum, object| sum + object.errors.count }
    unless count.zero?
      html = {}
      [:id, :class].each do |key|
        if options.include?(key)
          value = options[key]
          html[key] = value unless value.blank?
        else
          html[key] = 'errorExplanation'
        end
      end
      options[:object_name] ||= params.first
      options[:header_message] = '' unless options.include?(:header_message) #"#{pluralize(count, 'error')} prohibited this #{options[:object_name].to_s.gsub('_', ' ')} from being saved" 
      options[:message] ||= '' unless options.include?(:message) #'There were problems with the following fields:' 
      error_messages = objects.map {|object| object.errors.full_messages.map {|msg| content_tag(:li, msg) } }
      
      contents = ''
      contents << content_tag(options[:header_tag] || :h2, options[:header_message]) unless options[:header_message].blank?
      contents << content_tag(:p, options[:message]) unless options[:message].blank?
      contents << content_tag(:ul, error_messages)
      
      content_tag(:div, contents, html)
    else
      ''
    end
  end
end
