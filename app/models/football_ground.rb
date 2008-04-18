class FootballGround < ActiveRecord::Base
  include ModelHelper
  
  belongs_to :user
  
  has_many :trainings, 
    :extend => ActivityCalendar
  
  has_many :matches, 
    :extend => ActivityCalendar

  has_many :sided_matches, 
    :extend => ActivityCalendar   
    # comment this, since it set football_ground_id to null before we can modity the location
    # :dependent => :nullify
  
  has_many :plays, 
    :extend => ActivityCalendar
  
  GROUND_TYPE = (1..5).to_a #天然草场、人工草场、硬地场、土场、室内场
  STATUS = (0..2).to_a #待审核、通过、停用
  
  validates_presence_of     :name, :message => "请填写球场名称"
  validates_length_of        :name,    :maximum => 50, :message => "球场名称最长可以填50个字"
  
  validates_inclusion_of :ground_type, :in => GROUND_TYPE, :message => "不要自己构造表单提交..."
  validates_inclusion_of :status, :in => STATUS, :message => "不要自己构造表单提交..."
  validates_inclusion_of   :city, :in => ProvinceCity::CITY_VALUE_RANGE, :message => "不要自己构造表单提交..."
  
  validates_length_of        :description, :maximum => 3000, :allow_nil => true, :message => "球场描述最长可以填3000个字"
  
  def merge_to_and_delete(fg)
    FootballGround.transaction do
      Training.update_all(["location = ?", fg.name], ["football_ground_id = ?", self.id])
      Training.update_all(["football_ground_id = ?", fg.id], ["football_ground_id = ?", self.id])
      Play.update_all(["location = ?", fg.name], ["football_ground_id = ?", self.id])
      Play.update_all(["football_ground_id = ?", fg.id], ["football_ground_id = ?", self.id])
      Match.update_all(["location = ?", fg.name], ["football_ground_id = ?", self.id])
      Match.update_all(["football_ground_id = ?", fg.id], ["football_ground_id = ?", self.id])
      SidedMatch.update_all(["location = ?", fg.name], ["football_ground_id = ?", self.id])
      SidedMatch.update_all(["football_ground_id = ?", fg.id], ["football_ground_id = ?", self.id])
      FootballGround.delete(self.id)
    end
  end
  
  def before_destroy
    Training.update_all(["location = ?", self.name], ["football_ground_id = ?", self.id])
    Training.update_all("football_ground_id = NULL", ["football_ground_id = ?", self.id])
    Play.update_all(["location = ?", self.name], ["football_ground_id = ?", self.id])
    Play.update_all("football_ground_id = NULL", ["football_ground_id = ?", self.id])
    Match.update_all(["location = ?", self.name], ["football_ground_id = ?", self.id])
    Match.update_all("football_ground_id = NULL", ["football_ground_id = ?", self.id])
    SidedMatch.update_all(["location = ?", self.name], ["football_ground_id = ?", self.id])
    SidedMatch.update_all("football_ground_id = NULL", ["football_ground_id = ?", self.id])
  end
  
  def before_validation
    attribute_slice(:description, 3000)
  end
  
  attr_protected :status, :user_id
end
