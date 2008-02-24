class UserImage < ActiveRecord::Base
  WIDTH = 96
  HEIGHT = 96
  
  belongs_to :user  
  has_attachment  :storage => :file_system, 
                  :content_type => :image, 
                  :resize_to => '96x96!',
                  :thumbnails => { :small => "48x48!"},
                  :path_prefix => 'public/images/users',
                  :max_size => 2.megabytes,
                  :processor => :MiniMagick # attachment_fu looks in this order: ImageScience, Rmagick, MiniMagick

  validates_as_attachment # ok two lines if you want to do validation, and why wouldn't you?
  
  def uploaded_data=(file_data)
    return nil if file_data.nil? || file_data.size == 0
    self.content_type = file_data.content_type
    ext = nil
    file_data.original_filename.gsub(/\.\w+$/) do |s|
      ext = s; ''
    end
    self.filename = "u%08d#{ext}" % self.user_id if respond_to?(:filename)
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
end
