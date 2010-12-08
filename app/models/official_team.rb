class OfficialTeam < ActiveRecord::Base
  include ModelHelper
  
  DEFAULT_IMAGE = "/images/default_team.gif"
  
  has_one :official_team_image,
            :dependent => :destroy
  
  belongs_to :user
  
  validates_presence_of     :name, :message => "请填写队名"
  validates_length_of        :name, :maximum => 15, :message => "球队全名最长可以填15个字"
  validates_length_of        :description,    :maximum => 3000, :allow_nil=>true, :message => "球队简介最长可以填3000个字"
  validates_inclusion_of    :category, :in => OfficialTeamModule::CATEGORY_LIST, :message => "不要自己构造表单提交..."
  
  attr_protected :user_id
  
  def before_validation
    self.category = 7 if category.nil?
    attribute_slice(:description, 3000)
  end
  
  def image(thumbnail = nil, refresh = nil)
    if refresh == :refresh && self.official_team_image != nil
      self.image_path = self.official_team_image.public_filename
      self.save
      return self.official_team_image.public_filename(thumbnail) 
    end
    if self.image_path != nil
      if thumbnail == nil
        self.image_path
      else
        self.image_path.split('.').insert(1, "_#{thumbnail}.").join
      end
    else
      if thumbnail == nil
        DEFAULT_IMAGE
      else
        DEFAULT_IMAGE.split('.').insert(1, "_#{thumbnail}.").join
      end
    end
  end

  def merge(team2)
    if self.category == 7 && team2.category !=7
      self.category = team2.category
    end
    if self.description.blank? && !team2.description.blank?
      self.description = team2.description
    end
    if self.image_path.nil? && !team2.image_path.nil?
      self.image_path = team2.image_path
    end
    self.save!

    OfficialMatch.update_all(["host_official_team_id=?", self.id], :host_official_team_id => team2.id)
    OfficialMatch.update_all(["guest_official_team_id=?", self.id], :guest_official_team_id => team2.id)
  end
end
