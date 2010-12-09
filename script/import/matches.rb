require 'rubygems'
require 'nokogiri'
require 'open-uri'

require File.dirname(__FILE__) + '/extractor/netease'

MATCH_TYPE = {
  :england => :england, #英超
  :spain => :spain, #西甲
  :italy => :italy, #意甲
  :germany => :germany, #德甲
  :france => :france, #法甲
  :euro => :euro, #冠军联赛
  :eurolg => :eurolg, #欧洲联赛
  :all => :all
}

begin
  if ARGV.length >= 4
    dates = [DateTime.parse(ARGV[-2])]
    type = ARGV[-1].downcase.to_sym
  elsif ARGV.length == 3
    dates = [DateTime.parse(ARGV[-1])]
    type = :all
  else
    dates = [DateTime.yesterday, DateTime.now, DateTime.now + 7.days]
    type = :all
  end
rescue
  puts "Usage: ruby script\/runner -e ENV script\import\matches.rb [DateTime] [MatchType]"
  exit
end

#####################
# Extract Matches
#####################
matches = []
begin
  dates.each do |date|
    puts "* #{date.strftime("%Y-%m-%d")}:"
    puts "  Import #{type} matches from #{src_uri(date, type)}."
    tmp = extract_matches(date, type)
    puts "  Extract #{tmp.length} matches."
    matches << tmp
    matches.flatten!
    sleep(2)
    puts
  end
rescue
  puts "* Remote Extract Error!"
  puts
end

puts "-----------------------"
puts

#####################
# Import Matches
#####################
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
    puts "* Import Error!"
    puts
  end

  puts "* New Teams:"
  new_teams.each do |t|
    puts "  #{t.name}"
  end
  puts

  puts "* New Matches:"
  new_matches.each do |m|
    if m.host_team_goal.nil? || m.guest_team_goal.nil?
      puts "  #{m.host_team_name} V.S. #{m.guest_team_name} at #{m.start_time.strftime("%Y-%m-%d %H:%M")}"
    else
      puts "  #{m.host_team_name} #{m.host_team_goal} : #{m.guest_team_goal} #{m.guest_team_name} at #{m.start_time.strftime("%Y-%m-%d %H:%M")}"
    end
  end
  puts

  puts "* Update Matches:"
  update_matches.each do |m|
    if m.host_team_goal.nil? || m.guest_team_goal.nil?
      puts "  #{m.host_team_name} V.S. #{m.guest_team_name} at #{m.start_time.strftime("%Y-%m-%d %H:%M")}"
    else
      puts "  #{m.host_team_name} #{m.host_team_goal} : #{m.guest_team_goal} #{m.guest_team_name} at #{m.start_time.strftime("%Y-%m-%d %H:%M")}"
    end
  end
else
  puts "* Import Nothing."
end
