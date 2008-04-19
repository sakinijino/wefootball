class JsController < ApplicationController
  caches_page :province_city_select#, :football_ground_select

  def province_city_select
    respond_to do |format|
      format.js {
      }
    end
  end
  
  def football_ground_select
    @fooball_grounds = FootballGround.find_all_by_status(1)
    @fooball_ground_list = {}
    @fooball_grounds.each {|f| @fooball_ground_list[f.id]=f.name}
    @city_fooball_ground_list = {}
    @fooball_grounds.each  do |f| 
      @city_fooball_ground_list[f.city] = [] if @city_fooball_ground_list[f.city] == nil
      @city_fooball_ground_list[f.city] << f.id
    end
    @fooball_ground_reverse_list = {}
    @fooball_grounds.each {|f| @fooball_ground_reverse_list[f.id]=f.city}
    respond_to do |format|
      format.js {
      }
    end
  end
end
