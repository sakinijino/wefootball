class TeamImage < ActiveRecord::Base
  WIDTH = 100
  HEIGHT = 100
  
  belongs_to :team
  has_attachment  :storage => :file_system, 
                  :content_type => :image, 
                  :resize_to => '100x100!',
                  :path_prefix => 'public/images/teams',
                  :max_size => 2.megabytes,
                  :processor => :MiniMagick # attachment_fu looks in this order: ImageScience, Rmagick, MiniMagick

  validates_as_attachment # ok two lines if you want to do validation, and why wouldn't you?
  
  def uploaded_data=(file_data)
    return nil if file_data.nil? || file_data.size == 0
    self.content_type = file_data.content_type
    self.filename = file_data.original_filename if respond_to?(:filename)
    if file_data.is_a?(StringIO)
      file_data.rewind
      self.temp_data = file_data.read
    else
      self.temp_data = file_data.read #windows fix
    end
  end
  
  def full_filename(thumbnail = nil)
    file_system_path = (thumbnail ? thumbnail_class : self).attachment_options[:path_prefix].to_s
    File.join(RAILS_ROOT, file_system_path, thumbnail_name_for(thumbnail))
  end
  
  def thumbnail_name_for(thumbnail = nil)
    ext = nil
    filename.gsub(/\.\w+$/) do |s|
      ext = s; ''
    end
    # ImageScience doesn't create gif thumbnails, only pngs
    ext.sub!(/gif$/, 'png') if attachment_options[:processor] == "ImageScienceProcessor"
    return "t%08d#{ext}" % self.team_id.to_s if thumbnail.blank?
    "t%08d_#{thumbnail}#{ext}" % self.team_id.to_s
  end
end
