require 'rubygems'
require 'nokogiri'
require 'open-uri'

require File.dirname(__FILE__) + '/extractor/netease'

MATCH_TYPE = {
  :england => '8', #英超
  :spain => '21', #西甲
  :italy => '23', #意甲
  :germany => '22', #德甲
  :euro => '5', #冠军联赛
}

date = {
  :year => ARGV[0],
  :month => ARGV[1],
  :day => ARGV[2]
}

matches = []

begin
  MATCH_TYPE.each do |type,w|
    doc = Nokogiri::HTML(open(src_uri(date[:year], date[:month], date[:day], type)), 'utf8')
    matches << extract_matches(doc, date[:year], date[:month], date[:day])
    matches.flatten!
    sleep(2)
  end
rescue
  puts "Remote Extract Error!"
 puts
end

new_teams = []
new_matches = []
update_matches = []

if matches.length > 0
  begin 
    matches.each do |m|
      OfficialMatch.import_match m do |nt, nm, um|
        new_teams<< nt
        new_teams.flatten!
        new_matches<< nm
        new_matches.flatten!
        update_matches<< um
        update_matches.flatten!
      end
    end
  rescue
    puts "Import Error!"
    puts
  end

  puts "New Teams:"
  new_teams.each do |t|
    puts t.name
  end
  puts

  puts "New Matches:"
  new_matches.each do |m|
    if m.host_team_goal.nil? || m.guest_team_goal.nil?
      puts "#{m.host_team_name} V.S. #{m.guest_team_name} at #{m.start_time.strftime("%Y-%m-%d %H:%M")}"
    else
      puts "#{m.host_team_name} #{m.host_team_goal} : #{m.guest_team_goal} #{m.guest_team_name} at #{m.start_time.strftime("%Y-%m-%d %H:%M")}"
    end
  end
  puts

  puts "Update Matches:"
  update_matches.each do |m|
    if m.host_team_goal.nil? || m.guest_team_goal.nil?
      puts "#{m.host_team_name} V.S. #{m.guest_team_name} at #{m.start_time.strftime("%Y-%m-%d %H:%M")}"
    else
      puts "#{m.host_team_name} #{m.host_team_goal} : #{m.guest_team_goal} #{m.guest_team_name} at #{m.start_time.strftime("%Y-%m-%d %H:%M")}"
    end
  end
else
  puts "Import Nothing."
end
